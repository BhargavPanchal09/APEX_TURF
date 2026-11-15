package org.example.service;

import org.example.dao.UserDao;
import org.example.model.User;
import java.sql.SQLException;

public class UserService {
    private final UserDao userDao = new UserDao();
    private final PasswordService passwordService = new PasswordService();

    public void register(User user) throws SQLException, IllegalArgumentException {
        if (user.getName() == null || user.getName().isBlank() || user.getName().length() > 100) {
            throw new IllegalArgumentException("Enter a name of 1 to 100 characters.");
        }
        user.setName(user.getName().trim());
        if (user.getEmail() == null || !user.getEmail().matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$") || user.getEmail().length() > 150) {
            throw new IllegalArgumentException("Enter a valid email address.");
        }
        user.setEmail(user.getEmail().trim().toLowerCase(java.util.Locale.ROOT));
        if (user.getPhone() == null || user.getPhone().isBlank() || user.getPhone().length() > 32) {
            throw new IllegalArgumentException("Enter a phone number of up to 32 characters.");
        }
        user.setPhone(user.getPhone().trim());
        if (user.getPassword() == null || user.getPassword().length() < 8 || user.getPassword().getBytes(java.nio.charset.StandardCharsets.UTF_8).length > 72) {
            throw new IllegalArgumentException("Password must be at least 8 characters and no more than 72 UTF-8 bytes.");
        }
        if (userDao.findByEmail(user.getEmail()) != null) {
            throw new IllegalArgumentException("Email is already in use.");
        }
        // Hash the password before saving
        String hashedPassword = passwordService.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
        userDao.create(user);
    }

    public User login(String email, String password) throws SQLException {
        if (email == null || password == null || password.isEmpty()) return null;
        email = email.trim().toLowerCase(java.util.Locale.ROOT);
        User user = userDao.findByEmail(email);
        if (user != null && passwordService.checkPassword(password, user.getPassword())) {
            return user; // Login successful
        }
        return null; // Login failed
    }
}
