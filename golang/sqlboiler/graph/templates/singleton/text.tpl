import (
	"errors"
)

// Text represents a custom GraphQL "Text" scalar type
// Implements graphql.Unmarshaler
type Text string

// ImplementsGraphQLType returns the GraphQL type name
func (Text) ImplementsGraphQLType(name string) bool {
	return name == "Text"
}

// UnmarshalGraphQL unmarshals the GraphQL type
func (i *Text) UnmarshalGraphQL(input interface{}) error {
	var err error
	switch input := input.(type) {
	case string:
		*i = Text(input)
	default:
		err = errors.New("wrong type: expecting string format for Text types")
	}
	return err
}

// MarshalJSON implements JSON marshalling
func (i Text) MarshalJSON() ([]byte, error) {
	return []byte(i), nil
}

// ToGo converts the custom scalar type to Go type
func (i *Text) ToGo() ([]byte, error) {
	return []byte(*i), nil
}
