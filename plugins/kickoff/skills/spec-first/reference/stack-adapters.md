# Stack adapters — 6-block core → concrete per stack

The six spec blocks are stack-independent. These blocks need translation to your
stack: **Data Model, API, Background, ML-inference, Security**. Add a row per new
stack — never assume Supabase.

| Block | Supabase / Next | Python / FastAPI |
|---|---|---|
| Data Model | tables + RLS | SQLAlchemy + Pydantic models; permissions at the service layer |
| API | Server Actions / Edge | FastAPI routes: method, path, Pydantic in/out schemas, status codes |
| Background / cron | Edge Functions cron | Celery / APScheduler tasks |
| ML-inference | — | model service wrapper (ONNX / FAISS), in/out contract, latency budget |
| Security | RLS policies | on-premise perimeter, de-identification, auth middleware |

**Adding a stack:** copy the block column, fill each row with that stack's concrete
mechanism. Keep volatile specifics here (one-line edits) rather than woven through
prose elsewhere.
