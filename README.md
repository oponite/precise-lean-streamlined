# PLS: Stop Telling Your Agent "that's not what I meant"

PLS is an AI-friendly framework for code design, implementation, refactoring, and review.

PLS is available as a skill, a Homebrew tool, and a VSCode extension.

## Installation

Run in command line:

```Shell
curl -fsSL https://raw.githubusercontent.com/vijayneelakantan/precise-lean-streamlined/main/install-pls.sh | bash
```

## Why PLS

Consider this historical return analysis prompt:

> Print QQQ returns when price is above SMA 50. Use yfinance for data.

The agent makes the assumption "user wants average daily return on days when QQQ closes above its 50-day SMA" and produces this:

```Python
import yfinance as yf

data = yf.download(
    "QQQ",
    period="1y",
    auto_adjust=True,
    multi_level_index=False,
    progress=False,
)
close = data["Close"]

returns = close.pct_change()
print(returns[close > close.rolling(50).mean()].mean())
```

If interpreted as a trading signal for earning that same day's return, the introduces **look-ahead bias;** it doesn't make sense to treat today's closing regime as a signal for earning today's return.

Consider the same prompt, but instruct the agent to use PLS:

> Print QQQ returns when price is above SMA 50. Use yfinance for data, PLS for implementation.

PLS requires the agent to distingush requirements from assumptions and make unresolved assumptions explicit:

> "Do you mean returns on *days that close above SMA 50*, or *the following day's returns after a close above SMA 50?* Should I print each returns, their average, or a compounded total?

PLS lets the agent exposes choices based on semantical interpretations. It resolves unspecified choices from context, asks when needed, or states assumptions before implementation.

Let's pick the latter interpretation: *following day's returns after a close above SMA 50*. Assuming one year of daily adjusted princes, the agent prints individual next-day returns, indexed by the date above the above-SMA signal:

```python
import yfinance as yf

data = yf.download(
    "QQQ",
    period="1y",
    auto_adjust=True,
    multi_level_index=False,
    progress=False,
)
close = data["Close"]
sma_50 = close.rolling(50).mean()

# Each value is the next day's return, indexed by the signal date.
next_day_returns = close.shift(-1) / close - 1
print(next_day_returns[close > sma_50].dropna())
```

See [practical examples](EXAMPLES.md) for duplicate removal, task counting, and display-name validation.

## Methodology

First, an agent uses the prompt to decide on an implementation mode:

| Mode    | Use it when                                                     |
| ------- | --------------------------------------------------------------- |
| Simple  | The change is straightforward, bounded, and has known behavior. |
| Complex | The change is ambiguous, risky, cross-boundary, or non-trivial. |

Then, the agent abides by these principles to clarify specifications:

| Principle   | Question                                    |
| ----------- | ------------------------------------------- |
| Precise     | What must become true?                      |
| Lean        | What semantic work makes it true?           |
| Streamlined | Why does each operation and artifact exist? |

Semantic contract = what goes in, what should happen, what is the expected outcome, what counts as correct for the outcome

PLS then guides implementation: keep only the operations needed to meet the requirements, remove anything that serves no necessary purpose, and verify that the result behaves as intended - including relevant failure cases and real system interactions.
