package echo

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// -- tests --
func TestEcho_U(t *testing.T) {
	share := New("test message")

	res, err := share.Call()
	assert.Equal(t, nil, err)
	assert.Equal(t, "test message", res)
}
