package com.wildguard.backend.modules.user.service;

import com.wildguard.backend.modules.user.dto.RangerProfileResponse;
import com.wildguard.backend.modules.user.model.User;

public interface UserService {

    RangerProfileResponse getRangerProfile(String username);

    RangerProfileResponse updateProfile(String username, java.util.Map<String, String> changes);

    User findByUsername(String username);

    User findById(String id);
}
