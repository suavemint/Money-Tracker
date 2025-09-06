# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Money Tracker is a Ruby on Rails 8.0 financial management application that allows users to:
1. Upload PDF statements from banks, credit cards, and other financial institutions
2. Automatically parse and categorize transactions
3. Track spending across different categories
4. Calculate account balances and financial summaries

## Development Setup

### Prerequisites
- Ruby 3.4.5 (installed via Homebrew)
- PostgreSQL 15 (installed via Homebrew)
- Rails 8.0.2.1

### Environment Setup
```bash
# Essential PATH setup - run this before any Rails commands
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Start PostgreSQL service
brew services start postgresql@15
```

### Common Development Commands

#### Database Commands
```bash
bin/rails db:create          # Create databases
bin/rails db:migrate         # Run migrations
bin/rails db:seed           # Seed with default categories and sample data
bin/rails db:reset          # Drop, create, migrate, and seed
```

#### Server Commands
```bash
bin/rails server            # Start development server (port 3000)
bin/dev                     # Start with Procfile (includes hot reloading)
```

#### Testing Commands
```bash
bin/rails test              # Run all tests
bin/rails test:system       # Run system tests
bin/rubocop                 # Run linter
bin/brakeman                # Run security scanner
```

#### Generation Commands
```bash
bin/rails generate model ModelName field:type
bin/rails generate controller ControllerName action1 action2
bin/rails generate migration MigrationName
```

## Architecture Overview

### Core Models
- **Account**: Represents bank accounts, credit cards, etc.
  - Fields: name, account_type, account_number, institution, current_balance
  - Types: checking, savings, credit_card, investment, loan, other
  
- **Category**: Transaction categorization system
  - Fields: name, color (hex), description
  - Pre-seeded with common categories (Groceries, Transportation, Salary, etc.)
  
- **Statement**: PDF bank statements uploaded by users
  - Fields: filename, upload_date, file_content (parsed text)
  - Has attached file via Active Storage
  - Contains PDF parsing logic using pdf-reader gem
  
- **Transaction**: Individual financial transactions
  - Fields: amount, description, transaction_date, transaction_type (credit/debit)
  - Belongs to Account, Category, and optionally Statement
  - Includes scopes for income, expenses, and date filtering

### Key Relationships
```
Account (1) -> (many) Statements
Account (1) -> (many) Transactions
Category (1) -> (many) Transactions
Statement (1) -> (many) Transactions (optional)
```

### Controllers Structure
- **DashboardController**: Main financial overview and summaries
- **AccountsController**: Account CRUD operations
- **TransactionsController**: Transaction management and categorization
- **CategoriesController**: Category management
- **StatementsController**: PDF upload and parsing

### Frontend Technology
- **Hotwire/Turbo**: SPA-like experience with server-rendered HTML
- **Stimulus**: Minimal JavaScript for interactions
- **Importmap**: Modern JavaScript without bundling
- **CSS**: Standard CSS with Rails asset pipeline

### PDF Processing
The Statement model includes automatic PDF parsing functionality:
- Uses `pdf-reader` gem to extract text from uploaded PDFs
- Basic pattern matching to identify transactions
- Automatically creates Transaction records with default categorization
- Handles various bank statement formats (extensible)

## File Structure Highlights

### Models Location
- `app/models/account.rb` - Account model with balance calculations
- `app/models/category.rb` - Category model with color validation
- `app/models/statement.rb` - PDF processing and transaction extraction
- `app/models/transaction.rb` - Core transaction logic and scopes

### Key Configuration
- `config/database.yml` - PostgreSQL configuration
- `config/routes.rb` - RESTful routing structure
- `db/seeds.rb` - Default categories and sample data
- `Gemfile` - Dependencies including pdf-reader and image_processing

### Migration Files
Located in `db/migrate/` with timestamps:
- Account creation and fields
- Category structure
- Statement file handling
- Transaction relationships
- Statement ID made optional for manual transactions

## Development Guidelines

### Running the App Locally
1. Ensure PostgreSQL is running: `brew services start postgresql@15`
2. Set PATH environment variables (see Environment Setup)
3. Run `bin/rails db:setup` for first-time setup
4. Start server with `bin/rails server`
5. Visit http://localhost:3000

### Adding New Features
1. Generate models with proper relationships
2. Add validations and business logic to models
3. Create RESTful controllers following Rails conventions
4. Use Hotwire/Turbo for dynamic interactions
5. Add tests for new functionality

### PDF Parser Extension
To support new bank formats:
1. Extend `Statement#extract_transaction_from_line` method
2. Add format-specific regex patterns
3. Test with sample PDFs from different institutions

### Database Changes
Always create migrations for schema changes:
- Use descriptive migration names
- Include both `up` and `down` methods when needed
- Test migrations on development data

## Deployment

### GitHub Actions CI/CD
The project includes `.github/workflows/ci.yml` for:
- Running tests on multiple Ruby versions
- Security scanning with Brakeman
- Code quality checks with RuboCop
- Automated dependency updates via Dependabot

### Production Considerations
- Uses solid_cache, solid_queue, solid_cable for Rails 8 features
- Configured for PostgreSQL in production
- Includes Dockerfile for containerization
- Kamal deployment configuration included