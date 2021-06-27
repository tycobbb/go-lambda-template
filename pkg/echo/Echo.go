package echo

// -- types --

// Echo is a command that prints its argument
type Echo struct {
	// the message to echo
	message string
}

// -- impls --

// New inits a new share command
func New(message string) *Echo {
	return &Echo{
		message: message,
	}
}

// -- i/command

// invokes the echo command
func (e *Echo) Call() (string, error) {
	print(e.message)
	return e.message, nil
}
