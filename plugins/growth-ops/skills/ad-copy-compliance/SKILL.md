---
name: ad-copy-compliance
description: Screen ad copy (headlines, primary text, descriptions) for platform policy risk before launch. Use before submitting creative to Meta, Google, TikTok, or native ad networks.
argument-hint: "[paste ad copy]"
---

Screen the ad copy in $ARGUMENTS for policy risk. Check against these common
rejection triggers:

- Absolute or unverifiable claims ("guaranteed", "cure", "#1", "best")
- Before/after or personal-attribute targeting language ("you have," "are you struggling with")
- Missing required disclosures for the vertical (finance, health, subscriptions)
- Sensationalized or clickbait phrasing likely to trip "low-quality" or "engagement bait" filters
- Trademark or brand-name misuse

Output:
1. A risk rating per line: `Low`, `Medium`, `High`.
2. For every `Medium` or `High` line, a compliant rewrite that keeps the same angle.
3. A one-line summary verdict: safe to launch, needs the flagged rewrites, or high overall rejection risk.

Do not soften the rating to make copy look safer than it is — false negatives
here cost an ad account's standing.
