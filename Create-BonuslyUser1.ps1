# https://www.postman.com/


# ------------------------------------------------------------
# Creating a new user

$token = "Your Token"
$Header = @{
        "authorization" = "Bearer $token"
    }

$Body = @{
	email = "test.test1@com.au"
	first_name = "test"
	last_name = "test1"
	country = "au"
}

$Parameters = @{
    Method 		= "POST"
    Uri 		= "https://bonus.ly/api/v1/users"
	Headers     = $Header
    ContentType = "application/json"
	Body 		= ($Body | ConvertTo-Json) 
}

Invoke-RestMethod @Parameters


# ------------------------------------------------------------
# checking a user exists

$UserEmail = "someones-email@com.au"
$token = "Your Token"
$Header = @{
        "authorization" = "Bearer $token"
    }

$Parameters = @{
    Method 		= "GET"
    Uri 		= "https://bonus.ly/api/v1/users?limit=1&email=$UserEmail"
	Headers     = $Header
    ContentType = "application/json"
}

$UserDetails = Invoke-RestMethod @Parameters


