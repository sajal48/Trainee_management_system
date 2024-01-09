package com.bjitacademy.sajal48.ems.application.filters;
import com.bjitacademy.sajal48.ems.domian.credential.UserCredential;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
@Service
@ConfigurationProperties(prefix = "jwt")
public class JwtService {
    private String secretKey;
    public String getSecretKey() {
        return secretKey;
    }
    public void setSecretKey(String secretKey) {
        this.secretKey = secretKey;
    }
    public String extractUserEmail(String token) {
        try {
            return extractClaim(token, Claims::getSubject);
        } catch (ExpiredJwtException e) {
            return null;
        }
    }
    private <T> T extractClaim(String token, Function<Claims, T> claimResolver) {
        final Claims claims = extractAllClaims(token);
        return claimResolver.apply(claims);
    }
    private Claims extractAllClaims(String token) {
        return Jwts
                .parserBuilder()
                .setSigningKey(getSignKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
    private Key getSignKey() {
        byte[] keyByte = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyByte);
    }
    public String generateToken(UserCredential userCredential) {
        return generateToken(new HashMap<>(), userCredential);
    }
    public String generateToken(
            Map<String, Object> extraClaims,
            UserCredential userCredential
    ) {
        extraClaims.put("userId", userCredential.getUserId());
        extraClaims.put("role", userCredential.getRole().getName());
        return Jwts
                .builder()
                .setClaims(extraClaims)
                .setSubject(userCredential.getEmail())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 24))
                .signWith(getSignKey(), SignatureAlgorithm.HS256)
                .compact();
    }
    public boolean isTokenValid(String token, UserDetails userDetails) {
        try {
            final String username = extractUserEmail(token);
            return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
        } catch (ExpiredJwtException e) {
            return false;
        }
    }
    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }
    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }
}