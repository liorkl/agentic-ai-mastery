<!-- file: knowledge/ecosystem/api.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://platform.claude.com/docs/en/about-claude/models/overview -->
<!-- curriculum_level: L7+ -->

# Claude API for Developers

## Current State

The Claude API enables developers to build applications with Claude's capabilities. Understanding the API helps leverage Claude Code's automation features and build custom tooling.

## API Basics

### Authentication

```bash
# Environment variable
export ANTHROPIC_API_KEY="sk-ant-..."

# Or in code
anthropic.Anthropic(api_key="sk-ant-...")
```

### Basic Request (Python)

```python
import anthropic

client = anthropic.Anthropic()

message = client.messages.create(
    model="claude-opus-5",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Hello, Claude!"}
    ]
)

print(message.content[0].text)
```

### Basic Request (TypeScript)

```typescript
import Anthropic from "@anthropic-ai/sdk";

const client = new Anthropic();

const message = await client.messages.create({
  model: "claude-opus-5",
  max_tokens: 1024,
  messages: [
    { role: "user", content: "Hello, Claude!" }
  ],
});

console.log(message.content[0].text);
```

## Tool Use (Function Calling)

### Defining Tools

```python
tools = [
    {
        "name": "get_weather",
        "description": "Get current weather for a location",
        "input_schema": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "City name"
                }
            },
            "required": ["location"]
        }
    }
]
```

### Handling Tool Calls

```python
response = client.messages.create(
    model="claude-opus-5",
    max_tokens=1024,
    tools=tools,
    messages=[{"role": "user", "content": "What's the weather in Tokyo?"}]
)

# Check for tool use
for block in response.content:
    if block.type == "tool_use":
        tool_name = block.name
        tool_input = block.input
        # Execute tool and return result
```

## Streaming

### Basic Streaming

```python
with client.messages.stream(
    model="claude-opus-5",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Write a story"}]
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
```

## Adaptive Thinking + Effort

The old `thinking={"type": "enabled", "budget_tokens": N}` form is removed on the 4.6+ family (it 400s). Use **adaptive thinking** and control depth with the **effort** parameter:

```python
response = client.messages.create(
    model="claude-opus-5",
    max_tokens=16000,
    thinking={"type": "adaptive"},
    output_config={"effort": "high"},  # low | medium | high | xhigh | max
    messages=[{"role": "user", "content": "Solve this complex problem..."}]
)
```

There is no separate thinking-token budget to set — Claude decides how much to think, and `effort` scales the overall depth and spend.

## Batch API

For async, non-interactive workloads (50% cheaper):

```python
# Create batch
batch = client.messages.batches.create(
    requests=[
        {
            "custom_id": "request-1",
            "params": {
                "model": "claude-sonnet-5",
                "max_tokens": 1024,
                "messages": [{"role": "user", "content": "..."}]
            }
        }
        # ... more requests
    ]
)

# Poll for completion
batch = client.messages.batches.retrieve(batch.id)
# then stream results; key them by custom_id, never by position
```

## Prompt Caching

Reduce costs for repeated prefixes:

```python
response = client.messages.create(
    model="claude-opus-5",
    max_tokens=1024,
    system=[
        {
            "type": "text",
            "text": "Long system prompt...",
            "cache_control": {"type": "ephemeral"}
        }
    ],
    messages=[{"role": "user", "content": "Question"}]
)
```

**Cache benefits**:
- Writes: 25% more expensive
- Reads: 90% cheaper
- TTL: 5 minutes (refreshed on use)

## Running an Agent Loop

There is no `Agent` class in the `anthropic` package. Two different things get called "the agent SDK" — know which one you want:

**Tool Runner** — part of the regular Anthropic SDK. It drives the request → execute → loop cycle over tools *you* define:

```python
from anthropic import Anthropic, beta_tool

client = Anthropic()

@beta_tool
def get_weather(city: str) -> str:
    """Look up the weather for a city."""
    return fetch_weather(city)

runner = client.beta.messages.tool_runner(
    model="claude-opus-5",
    max_tokens=4096,
    tools=[get_weather],
    messages=[{"role": "user", "content": "What's the weather in Haifa?"}],
)
result = runner.until_done()
```

**Claude Agent SDK** — a *separate package* (`claude-agent-sdk`), which is Claude Code packaged as a library. It ships built-in tools (read/write/edit, bash, grep, web search), the agent loop, subagents, and permissions:

```python
from claude_agent_sdk import query

async for message in query(prompt="Fix the failing test", options={...}):
    print(message)
```

Both are harness-only — you host them. If you want Anthropic to run the loop *and* host the tool sandbox, that's Managed Agents.

## Computer Use

For GUI automation (beta):

Anthropic-defined tool `type` strings are **dated and versioned** — copy the current one from the docs rather than reusing a version you remember. The `_20241022` generation is long superseded. Current examples:

```python
tools = [
    {"type": "bash_20250124", "name": "bash"},
    {"type": "text_editor_20250728", "name": "str_replace_based_edit_tool"},
    # computer tool type: see the computer-use docs for the current dated version
]
```

These tools are schema-less — do **not** give them an `input_schema`.

## API Rate Limits

Rate limits are **per usage tier and per model**, and they change. Don't hardcode them
from a doc (including this one) — read your current limits from the response headers
(`anthropic-ratelimit-*`) or the Console, and see the
[rate limits docs](https://docs.claude.com/en/api/rate-limits) for the live table.

On a 429, respect the `retry-after` header. The SDKs retry 408/409/429/5xx twice by default.

## Integration with Claude Code

### Headless Mode Uses API

```bash
# This calls the API directly
claude -p "Fix this bug" --output-format json
```

### Custom Automation

```python
# Build custom tooling on same API
import anthropic
import subprocess

def claude_code_headless(prompt):
    result = subprocess.run(
        ["claude", "-p", prompt, "--output-format", "json"],
        capture_output=True,
        text=True
    )
    return json.loads(result.stdout)
```

## Cost Tracking

### Response Includes Usage

```python
response = client.messages.create(...)

print(f"Input tokens: {response.usage.input_tokens}")
print(f"Output tokens: {response.usage.output_tokens}")
```

### Calculate Costs

```python
def calculate_cost(usage, model="claude-opus-5"):
    rates = {
        "claude-fable-5": {"input": 10, "output": 50},
        "claude-opus-5": {"input": 5, "output": 25},
        "claude-sonnet-5": {"input": 2, "output": 10},
        "claude-haiku-4-5": {"input": 1, "output": 5},
    }
    rate = rates[model]
    input_cost = (usage.input_tokens / 1_000_000) * rate["input"]
    output_cost = (usage.output_tokens / 1_000_000) * rate["output"]
    return input_cost + output_cost
```

## Mastery Checks

- [ ] Can you make basic API requests?
- [ ] Do you understand tool use patterns?
- [ ] Can you implement streaming for long responses?
- [ ] Do you use Batch API for automation?
- [ ] Can you track and estimate costs?

## Official Resources

- [API Documentation](https://docs.anthropic.com/en/api)
- [Python SDK](https://github.com/anthropics/anthropic-sdk-python)
- [TypeScript SDK](https://github.com/anthropics/anthropic-sdk-typescript)
- [Agent SDK](https://docs.anthropic.com/en/docs/claude-code/sdk)
- [API Cookbook](https://github.com/anthropics/anthropic-cookbook)
