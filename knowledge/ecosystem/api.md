<!--
topic: Claude API for Developers
last_updated: February 2026
source_docs: curriculum-v1.1.md, cost-guide-v1.0.md
curriculum_level: L8+
-->

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
    model="claude-sonnet-4-20250514",
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
  model: "claude-sonnet-4-20250514",
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
    model="claude-sonnet-4-20250514",
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
    model="claude-sonnet-4-20250514",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Write a story"}]
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
```

## Extended Thinking

For complex reasoning tasks:

```python
response = client.messages.create(
    model="claude-opus-4-5-20251101",
    max_tokens=16000,
    thinking={
        "type": "enabled",
        "budget_tokens": 10000
    },
    messages=[{"role": "user", "content": "Solve this complex problem..."}]
)
```

## Batch API

For async, non-interactive workloads (50% cheaper):

```python
# Create batch
batch = client.batches.create(
    requests=[
        {
            "custom_id": "request-1",
            "params": {
                "model": "claude-sonnet-4-20250514",
                "max_tokens": 1024,
                "messages": [{"role": "user", "content": "..."}]
            }
        }
        # ... more requests
    ]
)

# Poll for completion
batch = client.batches.retrieve(batch.id)
```

## Prompt Caching

Reduce costs for repeated prefixes:

```python
response = client.messages.create(
    model="claude-sonnet-4-20250514",
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

## Claude Agent SDK

For building agent applications:

```python
from anthropic import Agent

agent = Agent(
    model="claude-sonnet-4-20250514",
    tools=[...],
    system_prompt="You are a helpful assistant..."
)

# Run agent loop
result = agent.run("Complete this task...")
```

### SDK Features

- Automatic tool execution
- State management
- Multi-turn conversations
- Error handling
- Cost tracking

## Computer Use

For GUI automation (beta):

```python
tools = [
    {"type": "computer_20241022", "display_width": 1920, "display_height": 1080},
    {"type": "text_editor_20241022"},
    {"type": "bash_20241022"}
]
```

## API Rate Limits

| Tier | Requests/min | Tokens/min | Tokens/day |
|------|--------------|------------|------------|
| Free | 5 | 10,000 | 100,000 |
| Tier 1 | 50 | 40,000 | 1,000,000 |
| Tier 2 | 1,000 | 80,000 | 2,500,000 |
| Tier 3 | 2,000 | 160,000 | 5,000,000 |
| Tier 4 | 4,000 | 400,000 | 10,000,000 |

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
def calculate_cost(usage, model="claude-sonnet-4"):
    rates = {
        "claude-sonnet-4": {"input": 3, "output": 15},
        "claude-opus-4-5": {"input": 15, "output": 75},
        "claude-haiku": {"input": 1, "output": 5}
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
