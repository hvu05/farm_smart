import express, { type Application } from "express";
import cors from "cors";
import routes from "./routes";
import { env } from "./config/env";
import { errorHandler } from "./middlewares/error.middleware";

const app: Application = express();

app.disable("x-powered-by");
app.use(cors({ origin: env.CORS_ORIGIN }));
app.use(express.json({ limit: "1mb" }));
app.use(express.urlencoded({ extended: true }));

app.get("/ping", (_req, res) => {
  res.json({ status: "ok" });
});

app.use("/api", routes);

// app.use(notFoundHandler);
app.use(errorHandler);

export default app;
