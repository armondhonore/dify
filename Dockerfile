FROM mirror.gcr.io/library/node:22-alpine

# Install build tools for native modules
RUN apk add --no-cache python3 make g++ git curl

# Install pnpm according to packageManager field (pnpm@11.6.0)
RUN npm install -g pnpm@11.6.0

WORKDIR /repo

# Copy workspace configuration
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json .npmrc* ./

# Install dependencies
RUN pnpm install --no-frozen-lockfile

# Copy source code
COPY . .

# Ensure standalone output is enabled in next.config
RUN sed -i "s/output.*'export'/output: 'standalone'/g" web/next.config.* 2>/dev/null || true
RUN sed -i "s/output.*\"export\"/output: 'standalone'/g" web/next.config.* 2>/dev/null || true

# Build the web application specifically to avoid OOM/failures in other workspaces
# Increase heap size for large Next.js builds
ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN pnpm --filter ./web run build

# Set runtime environment
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

# The standalone build for Next.js puts the server in .next/standalone
# For monorepos, it's often .next/standalone/web/server.js or similar
# We workdir to the standalone output location
WORKDIR /repo/web/.next/standalone

EXPOSE 3000

CMD ["node", "server.js"]