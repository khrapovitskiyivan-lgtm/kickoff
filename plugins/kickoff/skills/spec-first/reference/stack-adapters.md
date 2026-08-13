# Stack adapters — 6-block core → concrete per stack

The six spec blocks are stack-independent. These blocks need translation to your
stack: **Data Model, API, Background, ML-inference, Security**. Add a row per new
stack — never assume Supabase.

| Block | Supabase / Next | Python / FastAPI | Node / Express (or Hono) | Go (Gin / net/http) | Rust (Axum / Actix) |
|---|---|---|---|---|---|
| Data Model | tables + RLS | SQLAlchemy + Pydantic models; permissions at the service layer | Prisma / Drizzle models; Zod validation; authz in service layer | sqlc / GORM structs; validation at handler; authz in service layer | SQLx / Diesel structs; `validator`; authz in service layer |
| API | Server Actions / Edge | FastAPI routes: method, path, Pydantic in/out schemas, status codes | routes: method, path, Zod in/out schemas, status codes | handlers: method, path, request/response structs, status codes | handlers: method, path, serde in/out types, status codes |
| Background / cron | Edge Functions cron | Celery / APScheduler tasks | BullMQ / node-cron workers | goroutine workers / robfig/cron | tokio tasks / tokio-cron-scheduler |
| ML-inference | — | model service wrapper (ONNX / FAISS), in/out contract, latency budget | onnxruntime-node wrapper, in/out contract, latency budget | onnxruntime-go / gRPC to model service, in/out contract, latency budget | `ort` (ONNX Runtime) / tract, in/out contract, latency budget |
| Security | RLS policies | on-premise perimeter, de-identification, auth middleware | helmet + auth middleware, input validation, env secrets | middleware auth, context timeouts, env / vault secrets | tower middleware auth, input validation, env secrets |

**Adding a stack:** copy the block column, fill each row with that stack's concrete
mechanism. Keep volatile specifics here (one-line edits) rather than woven through
prose elsewhere.
