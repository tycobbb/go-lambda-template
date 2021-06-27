package main

import (
	"go-lambda-template/pkg/echo"

	"context"

	"github.com/aws/aws-lambda-go/lambda"
)

// -- types --

// Event (value) is the api event structure
type Event struct {
	Message string `json:"message"`
}

// -- impls --

// handles the lambda request
func handleRequest(ctx context.Context, event Event) (string, error) {
	// init command
	echo := echo.New(event.Message)

	// run command
	return echo.Call()
}

// -- boostrap --

// entry point for the lambda fn
func main() {
	lambda.Start(handleRequest)
}
