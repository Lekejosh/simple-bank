package util	

const (
	USD = "USD"
	EUR = "EUR"
	NGN = "NGN"
	CAD = "CAD"
)

func IsSupportedCurrency(currency string) bool {
	switch currency {
	case USD, EUR, CAD, NGN:
		return true
	}
	return false
}