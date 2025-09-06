class Statement < ApplicationRecord
  belongs_to :account
  has_many :transactions, dependent: :destroy
  has_one_attached :file

  validates :filename, presence: true
  validates :upload_date, presence: true

  def parse_pdf_content!
    return unless file.attached? && file.content_type == "application/pdf"

    require "pdf-reader"

    pdf_content = ""
    reader = PDF::Reader.new(file.download)
    reader.pages.each do |page|
      pdf_content += page.text
    end

    update!(file_content: pdf_content)
    extract_transactions_from_content
  rescue => e
    Rails.logger.error "PDF parsing error: #{e.message}"
  end

  private

  def extract_transactions_from_content
    # Basic transaction extraction logic
    # This would need to be customized for different bank formats
    lines = file_content.split("\n")

    lines.each do |line|
      # Look for date patterns and amounts
      if line.match?(/\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}/) && line.match?(/[-]?\$?\d+\.\d{2}/)
        extract_transaction_from_line(line)
      end
    end
  end

  def extract_transaction_from_line(line)
    # Basic pattern matching for transactions
    date_match = line.match(/\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}/)
    amount_match = line.match(/([-]?\$?)(\d+\.\d{2})/)

    if date_match && amount_match
      transaction_date = Date.parse(date_match[0])
      amount = amount_match[2].to_f
      amount = -amount if amount_match[1].include?("-")

      description = line.gsub(date_match[0], "").gsub(amount_match[0], "").strip

      # Create transaction with default category
      default_category = Category.find_or_create_by(name: "Uncategorized") do |cat|
        cat.color = "#808080"
        cat.description = "Default category for uncategorized transactions"
      end

      transactions.create!(
        account: account,
        category: default_category,
        amount: amount,
        description: description,
        transaction_date: transaction_date,
        transaction_type: amount > 0 ? "credit" : "debit"
      )
    end
  rescue => e
    Rails.logger.error "Transaction extraction error: #{e.message}"
  end
end
