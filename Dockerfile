FROM golang:1.19.1-buster as go-target
ADD . /hcl
WORKDIR /hcl
ENV GO111MODULE=off
RUN mkdir myfuzz
COPY fuzzers/fuzz.go ./myfuzz
WORKDIR ./myfuzz
RUN go get github.com/google/go-cmp/cmp
RUN go get github.com/hashicorp/hcl
RUN go build -o myfuzz

FROM golang:1.19.1-buster
COPY --from=go-target /hcl/myfuzz/myfuzz /
COPY --from=go-target /hcl/specsuite/tests/structure/attributes/*.hcl /testsuite/
COPY --from=go-target /hcl/specsuite/tests/expressions/*.hcl /testsuite/
COPY --from=go-target /hcl/specsuite/tests/comments/*.hcl /testsuite/

ENTRYPOINT []
CMD ["/myfuzz",  "@@"]
