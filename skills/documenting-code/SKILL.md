---
name: documenting-code
description: Documents code in a useful, developer-friendly way.
---

When documenting code, follow these principles inspired by well-documented projects like WordPress's HTML API (WP_HTML_Tag_Processor and WP_HTML_Processor):

# Core Principles

## 1. Self-Documenting Code First

Write code that explains itself through clear naming and structure. Documentation should complement, not substitute for, readable code.

**Good variable/function names:**
- `queueIndex` not `q` or `qi`
- `processNextHtmlTag()` not `process()` or `pnh()`
- `isAttributeValueQuoted` not `isQuoted` or `flag`
- `reconstructActiveFormattingElements()` not `reconstruct()`

**Bad variable/function names:**
- Single letters: `x`, `y`, `q`, `i` (except in obvious loop contexts)
- Cryptic abbreviations: `procHtml`, `getAttrVal`
- Generic names without context: `process()`, `handle()`, `temp`, `data`

## 2. Class-Level Documentation

Start with a concise statement of purpose.

**Good examples:**
```php
/**
 * Core class used to modify attributes in an HTML document for tags matching a query.
 *
 * This processor allows finding specific HTML tags and safely modifying their attributes
 * without breaking the document structure or requiring full DOM parsing.
 */
class WP_HTML_Tag_Processor {}
```

```typescript
/**
 * Manages user session state and handles authentication lifecycle events.
 *
 * Coordinates between the authentication provider, local storage, and
 * session refresh mechanisms to maintain a consistent user state.
 */
class SessionManager {}
```

**What makes these good:**
- Clear purpose statement
- Brief context about what problem it solves
- No marketing language or emojis
- Explains the "why" when it adds value

## 3. Method Documentation

Use brief, declarative descriptions starting with action verbs.

**Good examples:**
```php
/**
 * Returns the value of a requested attribute from a matched tag if it exists.
 *
 * @param string $name The attribute name to retrieve.
 * @return string|null The attribute value, or null if not found.
 */
public function get_attribute( $name ) {}

/**
 * Updates or creates a new attribute on the currently matched tag.
 *
 * @param string $name  The attribute name.
 * @param string $value The attribute value.
 */
public function set_attribute( $name, $value ) {}

/**
 * Indicates whether the current tag is a closing tag.
 *
 * @return bool True if the tag is a closer, false otherwise.
 */
public function is_tag_closer() {}
```

**Start with these verbs:**
- Returns, Gets, Retrieves (for getters)
- Updates, Sets, Modifies (for setters)
- Indicates, Checks, Determines (for boolean methods)
- Removes, Deletes, Clears (for destructive operations)
- Ensures, Validates, Verifies (for validation)

**Bad examples:**
```php
/**
 * Runs the tests
 */
function runTests() {} // Obvious from the name

/**
 * This function is used for the purpose of creating data
 */
function createData() {} // Verbose, obvious

/**
 * Magic happens here ✨
 */
function process() {} // Vague, emoji, uninformative
```

## 4. Inline Comments

Explain WHY, not WHAT. Comment on intent, constraints, edge cases, and non-obvious decisions.

**Good examples:**
```php
// HTML5 spec requires case-insensitive attribute matching, so normalize to lowercase
$attribute_name = strtolower( $name );

// Skip void elements (img, br, input, etc.) as they cannot have closing tags
// and the HTML5 parser doesn't expect them
if ( in_array( $tag_name, self::VOID_ELEMENTS, true ) ) {
    return false;
}

// Preserve existing whitespace between attributes to avoid breaking carefully
// formatted HTML or introducing visual regressions
$this->lexical_updates[] = array(
    'type' => 'add-attribute',
    'preserve_spacing' => true,
);
```

```typescript
// Cache the compiled regex to avoid recompiling on every validation call.
// Benchmarks show 40% performance improvement for repeated validations.
const emailRegex = compileEmailPattern();

// The API returns timestamps in seconds but Date expects milliseconds
const eventDate = new Date(response.timestamp * 1000);

// Defensive check: older API versions may omit the status field entirely
const isActive = response.status ?? true;
```

**Bad examples:**
```php
// Create the data
createData();

// Loop through items
foreach ($items as $item) {}

// Set the value to 10
$limit = 10;

// Important!!!
doSomething();

// TODO: fix this later (without explaining what needs fixing)
```

## 5. Documentation for Complex Logic

When logic is genuinely complex, explain the approach and constraints.

**Good example:**
```php
/**
 * Reconstructs the list of active formatting elements.
 *
 * This implements the HTML5 parsing algorithm's "reconstruction of active
 * formatting elements" step. When certain tags are encountered, previously-
 * opened formatting elements (like <b>, <i>, <a>) must be reopened to
 * maintain proper nesting, even if they were implicitly closed.
 *
 * For example, parsing "<b>Bold <p>Paragraph</b>" requires reopening the
 * <b> tag inside the <p> because block elements implicitly close formatting
 * elements, but those formatting elements are still "active" in the scope.
 */
private function reconstruct_active_formatting_elements() {
    // Algorithm implementation follows...
}
```

**Good example:**
```typescript
/**
 * Debounces rapid state changes to prevent thrashing the persistence layer.
 *
 * Without debouncing, typing in a text field triggers 60+ writes per second,
 * overwhelming IndexedDB and causing UI jank. This ensures we batch updates
 * while still providing sub-100ms perceived persistence for user actions.
 */
private debounceStateSync = debounce((state: AppState) => {
    this.persistenceLayer.save(state);
}, 50);
```

## 6. Edge Cases and Constraints

Document limitations, assumptions, and edge case handling.

**Good examples:**
```php
/**
 * Note: This method assumes the HTML is already UTF-8 encoded.
 * Other encodings must be converted before processing.
 */

/**
 * Warning: Bookmark names must be unique within a document.
 * Creating a bookmark with an existing name will silently fail.
 */

/**
 * Limitation: The parser does not support parsing document fragments
 * that start mid-attribute (e.g., starting with `="value"`).
 */
```

```typescript
/**
 * Handles file uploads up to 100MB. Larger files should use the
 * chunked upload API instead.
 *
 * @throws {FileSizeError} When file exceeds 100MB
 */
async function uploadFile(file: File): Promise<UploadResult> {}
```

## 7. What NOT to Document

**Don't document the obvious:**
```php
// Bad: Constructor creates an instance
public function __construct() {}

// Bad: Getter returns the name
public function getName() { return $this->name; }

// Bad: This sets the value
setValue(10);
```

**Don't use corporate speak or marketing language:**
```php
// Bad
/**
 * Leverages cutting-edge algorithms to synergize data optimization 🚀
 *
 * Key achievements:
 * - Best-in-class performance
 * - Enterprise-grade reliability
 */
```

**Don't add comments to unchanged code:**
When modifying a file, only add or update documentation for code you're changing or adding. Don't add docstrings, type annotations, or comments to existing code that's working and clear.

**Don't over-engineer documentation:**
```php
// Bad: Three lines of identical code don't need a helper function and docs
// Just write the three lines

// Bad: Don't create elaborate documentation for one-off operations
/**
 * Utility class for standardizing timestamps across the application.
 * Provides methods for timestamp normalization, validation, and formatting.
 * Follows ISO 8601 standards with timezone handling.
 */
class TimestampUtil {
    // Only used once in the entire codebase
}
```

# Examples: Good vs Bad

## Example 1: Processing a Queue

**Bad:**
```typescript
// Process queue
function pq(q: any[]) {
    // Loop
    for (let i = 0; i < q.length; i++) {
        // Do the thing
        q[i].process();
    }
}
```

**Good:**
```typescript
/**
 * Processes pending items in the task queue sequentially.
 *
 * Items are processed in FIFO order. If an item throws an error,
 * processing continues with the next item to prevent one failure
 * from blocking the entire queue.
 */
function processTaskQueue(queueItems: Task[]) {
    for (const task of queueItems) {
        try {
            task.process();
        } catch (error) {
            // Log but don't throw - queue processing should be resilient
            logger.error('Task processing failed', { task, error });
        }
    }
}
```

## Example 2: State Management

**Bad:**
```typescript
class SM {
    // State
    s: any;

    // Get state
    get() { return this.s; }

    // Update state 🎉
    upd(newS: any) {
        this.s = newS;
    }
}
```

**Good:**
```typescript
/**
 * Manages application state with immutable updates and change notification.
 *
 * State updates are immutable - each update creates a new state object
 * rather than mutating the existing one. This enables time-travel debugging
 * and simplifies change detection in React components.
 */
class StateManager<T> {
    private currentState: T;
    private listeners: Set<StateChangeListener<T>>;

    getState(): T {
        return this.currentState;
    }

    /**
     * Updates the application state and notifies all listeners.
     *
     * The updater function receives the current state and returns a new
     * state object. This ensures the update is based on the latest state,
     * preventing race conditions when multiple updates happen rapidly.
     */
    updateState(updater: (prevState: T) => T): void {
        const newState = updater(this.currentState);

        // Skip notification if state didn't actually change (reference equality)
        if (newState === this.currentState) {
            return;
        }

        this.currentState = newState;
        this.notifyListeners(newState);
    }
}
```

## Example 3: HTML Parsing

**Bad:**
```php
// Find tag
function ft($html, $tag) {
    // Regex to find it
    $p = '/<' . $tag . '.*?>/';
    preg_match($p, $html, $m);
    return $m[0];
}
```

**Good:**
```php
/**
 * Finds the next occurrence of a specified HTML tag in the document.
 *
 * This uses a streaming parser rather than regex to correctly handle:
 * - Quoted attributes containing angle brackets
 * - HTML comments and CDATA sections
 * - Malformed HTML with missing quotes or closing brackets
 *
 * @param string $tag_name The tag to find (case-insensitive).
 * @return bool True if tag was found, false otherwise.
 */
public function next_tag( $tag_name ) {
    // HTML5 requires case-insensitive tag matching
    $normalized_tag = strtoupper( $tag_name );

    while ( $this->next_token() ) {
        // Skip non-tag tokens (text, comments, etc.)
        if ( $this->token_type !== self::TOKEN_TYPE_TAG ) {
            continue;
        }

        if ( $this->tag_name === $normalized_tag ) {
            return true;
        }
    }

    return false;
}
```

# Summary

Good documentation:
- Uses descriptive names that reduce the need for comments
- Explains WHY, not WHAT
- Documents constraints, edge cases, and non-obvious decisions
- Uses clear, professional language
- Focuses on helping future developers (including yourself) understand intent
- Stays concise and relevant

Bad documentation:
- States the obvious
- Uses cryptic variable names requiring extensive comments
- Includes emojis or marketing speak
- Documents unchanged code during modifications
- Creates comments that just repeat the code in English
