FROM golang:1.15 as build

# set labels for metadata
LABEL maintainer="dixneuf19" \
  repo="https://github.com/dixneuf19/kube-validating-webhook-arm-check"

WORKDIR /workspace

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY cmd/ cmd/
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -a -o webhook main.go

# Use distroless as minimal base image to package the webhook binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/webhook .
USER nonroot:nonroot

ENTRYPOINT ["/webhook"]
