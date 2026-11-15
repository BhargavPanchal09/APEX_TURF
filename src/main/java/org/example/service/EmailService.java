package org.example.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.example.model.Booking;
import org.example.model.User;
import org.example.config.EnvironmentConfig;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.stream.Collectors;

public class EmailService {

    private final Properties props = new Properties();
    private final String senderEmail;
    private final String senderPassword;
    private final String adminEmail;

    public EmailService() {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("email.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (java.io.IOException ex) {
            throw new IllegalStateException("Unable to read email.properties", ex);
        }
        props.putIfAbsent("mail.smtp.host", "smtp.gmail.com");
        props.putIfAbsent("mail.smtp.port", "587");
        props.putIfAbsent("mail.smtp.auth", "true");
        props.putIfAbsent("mail.smtp.starttls.enable", "true");
        this.senderEmail = EnvironmentConfig.get("APEX_MAIL_SENDER", props.getProperty("sender.email"));
        this.senderPassword = EnvironmentConfig.get("APEX_MAIL_PASSWORD", props.getProperty("sender.password"));
        this.adminEmail = EnvironmentConfig.get("APEX_ADMIN_EMAIL", props.getProperty("admin.email"));
    }

    public void sendBookingConfirmation(User user, Booking booking) {
        String subject = "APEX TURF Booking Confirmation (ID: " + booking.getId() + ")";
        String body = loadTemplateAndReplace(
                "booking-confirmation.html", user, booking);
        send(user.getEmail(), subject, body);
        send(adminEmail, "[Admin] New Booking: " + booking.getId(), "A new booking was made by " + user.getName() + " for " + booking.getTurfName() + " at " + booking.getFormattedStartTime());
    }

    public void sendCancellationConfirmation(User user, Booking booking, String cancelledBy) {
        String subject = "APEX TURF Booking Cancellation (ID: " + booking.getId() + ")";
        String template = loadTemplate("booking-cancellation.html");

        String body = template
                .replace("{{userName}}", user.getName())
                .replace("{{bookingId}}", booking.getId().toString())
                .replace("{{turfName}}", booking.getTurfName())
                .replace("{{sportName}}", booking.getSportName())
                .replace("{{startTime}}", booking.getFormattedStartTime());

        // Send to user
        send(user.getEmail(), subject, body);
        // Send notification to admin
        send(adminEmail, "[Admin] Booking Cancelled: " + booking.getId(), "Booking " + booking.getId() + " was cancelled by " + cancelledBy);
    }

    public void sendUserCancellationConfirmation(User user, Booking booking) {
        String subject = "APEX TURF Booking Cancellation (ID: " + booking.getId() + ")";
        String body = loadTemplateAndReplace(
                "booking-cancellation.html", user, booking);
        send(user.getEmail(), subject, body);
        send(adminEmail, "[Admin] Booking Cancelled by User: " + booking.getId(), "Booking " + booking.getId() + " was cancelled by the user.");
    }

    private void send(String to, String subject, String htmlBody) {
        if (senderEmail == null || senderPassword == null || senderPassword.startsWith("YOUR_") ||
                to == null || to.isBlank() || to.contains("example.com")) {
            System.out.println("Email notifications are disabled; configure APEX_MAIL_SENDER, APEX_MAIL_PASSWORD, and APEX_ADMIN_EMAIL to enable them.");
            return;
        }
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email sent successfully to " + to);
        } catch (MessagingException e) {
            System.err.println("Failed to send email. Error: " + e.getMessage());
            e.printStackTrace();
            // In a real app, you would log this error more robustly
        }
    }

    public void sendAdminCancellationNotice(User user, Booking booking) {
        String subject = "APEX TURF Booking Update (ID: " + booking.getId() + ")";
        String body = loadTemplateAndReplace(
                "admin-cancellation.html", user, booking);
        send(user.getEmail(), subject, body);
    }

    // NEW METHOD for reconfirmations
    public void sendReconfirmationNotice(User user, Booking booking) {
        String subject = "APEX TURF Booking Re-Confirmed (ID: " + booking.getId() + ")";
        String body = loadTemplateAndReplace(
                "booking-reconfirmation.html", user, booking);
        send(user.getEmail(), subject, body);
        send(adminEmail, "[Admin] Booking Re-Confirmed: " + booking.getId(), "Booking " + booking.getId() + " was re-confirmed by an admin.");
    }

    private String loadTemplateAndReplace(String templateName, User user, Booking booking) {
        String template = loadTemplate(templateName);
        return template
                .replace("{{userName}}", user.getName())
                .replace("{{bookingId}}", booking.getId().toString())
                .replace("{{turfName}}", booking.getTurfName())
                .replace("{{sportName}}", booking.getSportName())
                .replace("{{startTime}}", booking.getFormattedStartTime())
                .replace("{{endTime}}", booking.getFormattedEndTime());
    }

    private String loadTemplate(String fileName) {
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("templates/" + fileName)) {
            if (is == null) throw new RuntimeException(fileName + " not found");
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                return reader.lines().collect(Collectors.joining(System.lineSeparator()));
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to load email template " + fileName, e);
        }
    }
}
