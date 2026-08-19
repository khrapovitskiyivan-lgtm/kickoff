# Stack adapters — translating the spec into your stack

Six of the spec blocks are stack-independent. **Five need translation before the spec is
buildable:** Data Model · API · Background / cron · ML-inference · Security.

**The rule: name the concrete mechanism your stack actually uses — and never default to the
stack you saw last.** "Store the leads" is not a Data Model; `SQLAlchemy model + Pydantic schema,
authorization in the service layer` is. Supabase/RLS is one answer among many, not the answer.

For each of the five, write what that stack really provides:

| Block | The question it must answer |
|---|---|
| Data Model | Where do rows live, how are they typed and validated, and **where is access enforced** — the DB (RLS/policies) or a service layer? |
| API | The concrete route/handler shape: method, path, request and response schemas, status codes. |
| Background / cron | What runs work off the request path — a queue, a scheduler, a serverless cron? |
| ML-inference | How the model is served, its in/out contract, and its latency budget. |
| Security | Which of the guards in `project-setup`'s `security-baseline.md` this stack expects you to build, and where each one lives. |

A worked translation for Python/FastAPI is in `example-spec.md`. Match its specificity, not its
stack — deriving the mechanisms for your own stack is the point of this step.
