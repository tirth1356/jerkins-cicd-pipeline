# Jenkins CI/CD Pipeline — Node.js App

A Node.js app with a Jenkins pipeline that automatically tests, builds, and pushes a Docker image to DockerHub on every push to `main`.

---

## Pipeline Stages

```
push to main
     │
     ▼
┌────────┐     ┌─────────┐     ┌──────────────┐     ┌─────────────────┐
│  Test  │────▶│  Build  │────▶│ Docker Build │────▶│ Push to DockerHub│
└────────┘     └─────────┘     └──────────────┘     └─────────────────┘
```

| Stage | What it does |
|---|---|
| Test | Installs dependencies, runs Jest tests |
| Build | Runs `npm run build` to verify the app builds |
| Docker Build | Builds image tagged as `latest` and `sha-<commit>` |
| Push to DockerHub | Pushes both tags to DockerHub (main branch only) |

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Node.js 20.x | Runtime |
| Express | Web framework |
| Jest | Testing |
| Docker (node:20-alpine) | Containerization |
| Jenkins | CI/CD automation |
| DockerHub | Image registry |

---

## Project Structure

```
├── .github/workflows/      # (optional) GitHub Actions workflows
├── source/
│   ├── _test_/             # Jest test files
│   ├── controllers/        # Route controllers
│   ├── models/             # Data models
│   ├── pages/              # HTML pages
│   └── routes/             # Express routes
├── Dockerfile              # Docker image definition
├── Jenkinsfile             # Jenkins pipeline definition
├── app.js                  # App entry point
└── package.json            # Dependencies and scripts
```

---

## API Endpoints

| Endpoint | Description |
|---|---|
| `GET /` | Home page |
| `GET /home` | Home page |
| `GET /today` | Today's date |
| `GET /months` | List of months |
| `GET /people` | List of people |

App runs on port `30002`.

---

## Run Locally

```bash
npm ci
npm test
npm start
# visit http://localhost:30002
```

---

## Jenkins Setup

### 1. Add DockerHub credentials

Go to `Manage Jenkins → Credentials → Global → Add Credentials`

| Field | Value |
|---|---|
| Kind | Username with password |
| Username | Your DockerHub username |
| Password | Your DockerHub access token |
| ID | `dockerhub-credentials` |

### 2. Create a Pipeline job

1. `New Item → Pipeline`
2. Under **Pipeline**, set Definition to `Pipeline script from SCM`
3. SCM: `Git` → paste your repo URL
4. Script Path: `Jenkinsfile`
5. Save and click **Build Now**

### 3. Auto-trigger on push (Webhook)

In Jenkins job → check `GitHub hook trigger for GITScm polling`

In GitHub repo → `Settings → Webhooks → Add webhook`
- Payload URL: `http://<your-jenkins-url>/github-webhook/`
- Content type: `application/json`
- Event: `Just the push event`

---

## Docker (manual)

```bash
docker build -t nodejs-demo-app .
docker run -p 30002:30002 nodejs-demo-app
```

---

## Required Jenkins Credentials

| Credential ID | Description |
|---|---|
| `dockerhub-credentials` | DockerHub username + access token |
