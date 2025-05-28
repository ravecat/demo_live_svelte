# Demo Live Svelte - Project Brief

## Overview
Phoenix LiveView application demonstrating integration with Svelte components for reactive form handling.

## Technical Stack
- **Backend**: Phoenix/Elixir
- **Frontend**: Svelte + Phoenix LiveView
- **Database**: PostgreSQL (via Ecto)
- **Styling**: Tailwind CSS + DaisyUI

## Architecture
Phoenix LiveView with embedded Svelte components for enhanced client-side reactivity while maintaining server-side state management.

### Key Features
- User registration and authentication
- Reactive form validation
- LiveView-Svelte data serialization
- Real-time UI updates

## Current Development Focus

### Active Module: User Registration
File: `lib/demo_phoenix_web/live/user_live/registration.ex`

#### Implementation Status
- ✅ Basic LiveView structure
- 🚧 Form data serialization (`prepare_form_data`)
- ⏳ Svelte component integration
- ⏳ Error handling and validation

#### Current Challenge
Implementing `prepare_form_data` function to serialize Phoenix.HTML.Form structures for consumption by Svelte components.

## Development Tasks

### Priority 1: Form Serialization
1. Complete `prepare_form_data` implementation
2. Handle form field serialization
3. Process validation errors for JSON output

### Priority 2: Svelte Integration  
1. Create `user/RegistrationForm` Svelte component
2. Establish LiveView ↔ Svelte communication
3. Implement reactive form validation

### Priority 3: Testing & Validation
1. Unit tests for serialization functions
2. Integration tests for LiveView-Svelte flow
3. End-to-end registration process validation

## System Patterns

### Form Data Serialization Pattern
Converting Phoenix.HTML.Form structures to JSON-compatible maps for Svelte component consumption, maintaining form state, validation errors, and field metadata.

## Project Structure
```
lib/demo_phoenix_web/live/user_live/
├── registration.ex          # Main LiveView module
└── ...                     # Other user-related LiveViews

assets/svelte/user/
└── RegistrationForm.svelte  # Planned Svelte component

priv/svelte/               # Svelte build output
└── user/
```

## Development Environment
- Elixir/Phoenix development server
- LiveReload for development
- Svelte compilation via esbuild
- Tailwind CSS processing