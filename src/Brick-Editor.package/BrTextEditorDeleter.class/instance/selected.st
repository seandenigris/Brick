api - configuration
selected
	"Mark currenty selected text as the one to be deleted"

	self editor selection do: [ :aMonotoneSelection | self from: aMonotoneSelection from to: aMonotoneSelection to ]