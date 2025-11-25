# Test script for authentication API

Write-Host "`n=== Testing TodoList Authentication API ===`n" -ForegroundColor Cyan

# Test 1: Signup
Write-Host "Test 1: User Signup" -ForegroundColor Yellow
try {
    $signupResponse = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/signup" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body '{"email":"testuser@example.com","password":"password123"}' `
        -UseBasicParsing
    
    Write-Host "✓ Signup successful!" -ForegroundColor Green
    $signupData = $signupResponse.Content | ConvertFrom-Json
    Write-Host $signupResponse.Content -ForegroundColor White
    $token = $signupData.data.token
} catch {
    Write-Host "✗ Signup failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        Write-Host $reader.ReadToEnd() -ForegroundColor Red
    }
}

Write-Host "`n---`n"

# Test 2: Duplicate signup (should fail)
Write-Host "Test 2: Duplicate Signup (should fail)" -ForegroundColor Yellow
try {
    $dupResponse = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/signup" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body '{"email":"testuser@example.com","password":"password123"}' `
        -UseBasicParsing
    Write-Host "✗ Duplicate signup should have failed!" -ForegroundColor Red
} catch {
    Write-Host "✓ Correctly rejected duplicate email" -ForegroundColor Green
    if ($_.Exception.Response) {
        $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        Write-Host $reader.ReadToEnd() -ForegroundColor White
    }
}

Write-Host "`n---`n"

# Test 3: Login
Write-Host "Test 3: User Login" -ForegroundColor Yellow
try {
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/login" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body '{"email":"testuser@example.com","password":"password123"}' `
        -UseBasicParsing
    
    Write-Host "✓ Login successful!" -ForegroundColor Green
    $loginData = $loginResponse.Content | ConvertFrom-Json
    Write-Host $loginResponse.Content -ForegroundColor White
    $token = $loginData.data.token
} catch {
    Write-Host "✗ Login failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n---`n"

# Test 4: Invalid login
Write-Host "Test 4: Invalid Login (should fail)" -ForegroundColor Yellow
try {
    $invalidResponse = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/login" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body '{"email":"testuser@example.com","password":"wrongpassword"}' `
        -UseBasicParsing
    Write-Host "✗ Invalid login should have failed!" -ForegroundColor Red
} catch {
    Write-Host "✓ Correctly rejected invalid password" -ForegroundColor Green
    if ($_.Exception.Response) {
        $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        Write-Host $reader.ReadToEnd() -ForegroundColor White
    }
}

Write-Host "`n---`n"

# Test 5: Get current user (protected route)
if ($token) {
    Write-Host "Test 5: Get Current User (Protected Route)" -ForegroundColor Yellow
    try {
        $meResponse = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/me" `
            -Method GET `
            -Headers @{"Authorization"="Bearer $token"} `
            -UseBasicParsing
        
        Write-Host "✓ Successfully retrieved user data!" -ForegroundColor Green
        Write-Host $meResponse.Content -ForegroundColor White
    } catch {
        Write-Host "✗ Failed to get user data: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "Test 5: Skipped (no token available)" -ForegroundColor Gray
}

Write-Host "`n---`n"

# Test 6: Protected route without token
Write-Host "Test 6: Protected Route Without Token (should fail)" -ForegroundColor Yellow
try {
    $noTokenResponse = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/me" `
        -Method GET `
        -UseBasicParsing
    Write-Host "✗ Should have rejected request without token!" -ForegroundColor Red
} catch {
    Write-Host "✓ Correctly rejected request without token" -ForegroundColor Green
    if ($_.Exception.Response) {
        $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        Write-Host $reader.ReadToEnd() -ForegroundColor White
    }
}

Write-Host "`n=== All Tests Completed ===`n" -ForegroundColor Cyan
