package com.wildguard.backend.modules.user.controller;

import com.wildguard.backend.modules.user.dto.RangerProfileResponse;
import com.wildguard.backend.modules.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import java.util.Map;

import java.security.Principal;

@Slf4j
@RestController
@RequestMapping("/api/rangers")
@RequiredArgsConstructor
public class RangerController {

    private final UserService userService;

    @GetMapping("/me")
    @PreAuthorize("hasRole('RANGER')")
    public ResponseEntity<RangerProfileResponse> getCurrentRangerProfile(Principal principal) {
        log.info("Request for current ranger profile by user: {}", principal.getName());
        RangerProfileResponse profile = userService.getRangerProfile(principal.getName());
        return ResponseEntity.ok(profile);
    }

    @GetMapping("/profile")
    @PreAuthorize("hasAnyRole('RANGER','LIAISON','VILLAGER','MANAGER')")
    public ResponseEntity<RangerProfileResponse> getProfile(Principal principal) {
        return ResponseEntity.ok(userService.getRangerProfile(principal.getName()));
    }

    @PutMapping("/profile")
    @PreAuthorize("hasAnyRole('RANGER','LIAISON','VILLAGER','MANAGER')")
    public ResponseEntity<RangerProfileResponse> updateProfile(Principal principal, @RequestBody Map<String, String> changes) {
        return ResponseEntity.ok(userService.updateProfile(principal.getName(), changes));
    }
}
