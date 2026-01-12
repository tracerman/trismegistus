# Reference Directory

This folder is for project-specific documentation and research that should be injected into AI prompts.

## Usage

Place markdown files here for:
- API documentation
- Architecture decisions
- Research notes
- External library guides

Files are automatically loaded based on keywords in your tasks.

## Examples

- `auth-architecture.md` - Authentication patterns for your app
- `api-spec.md` - Your API specification
- `stripe-integration.md` - Notes on Stripe setup
- `architecture_decision.md` - Output from `ai-architect` command

## Auto-Loading

When you run `ai-plan "Add Stripe payments"`, the system looks for files 
containing "stripe", "payment", etc. and includes them in context.
