package com.wildguard.backend.modules.user.service.impl;

import com.wildguard.backend.common.exception.ResourceNotFoundException;
import com.wildguard.backend.modules.user.dto.RangerProfileResponse;
import com.wildguard.backend.modules.user.model.User;
import com.wildguard.backend.modules.user.repository.UserRepository;
import com.wildguard.backend.modules.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Override
    public RangerProfileResponse getRangerProfile(String username) {
        log.info("Fetching ranger profile for username: {}", username);
        User user = findByUsername(username);

        return RangerProfileResponse.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .badgeNumber(user.getBadgeNumber())
                .role(user.getRole())
                .assignedPark(user.getAssignedPark())
                .phoneNumber(user.getPhoneNumber())
                .createdAt(user.getCreatedAt())
                .build();
    }

    @Override
    public RangerProfileResponse updateProfile(String username, java.util.Map<String, String> changes) {
        User user = findByUsername(username);
        if (changes.containsKey("fullName")) user.setFullName(changes.get("fullName"));
        if (changes.containsKey("email")) user.setEmail(changes.get("email"));
        if (changes.containsKey("phoneNumber")) user.setPhoneNumber(changes.get("phoneNumber"));
        if (changes.containsKey("assignedPark") && (user.getRole().name().equals("ROLE_LIAISON") || user.getRole().name().equals("ROLE_RANGER"))) user.setAssignedPark(changes.get("assignedPark"));
        return getRangerProfile(userRepository.save(user).getUsername());
    }

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));
    }

    @Override
    public User findById(String id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with ID: " + id));
    }
}
