package org.example.config;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

/** Reads process environment values first, then optional local .env values. */
public final class EnvironmentConfig {
    private static final Map<String, String> DOT_ENV = loadDotEnv();

    private EnvironmentConfig() {}

    public static String get(String key, String fallback) {
        String value = System.getenv(key);
        if (value == null || value.isBlank()) value = DOT_ENV.get(key);
        return value == null || value.isBlank() ? fallback : value;
    }

    private static Map<String, String> loadDotEnv() {
        Map<String, String> values = new HashMap<>();
        Path file = Path.of(System.getProperty("apex.env.file", ".env"));
        if (!Files.isRegularFile(file)) return values;
        try {
            for (String line : Files.readAllLines(file)) {
                String entry = line.trim();
                if (entry.isEmpty() || entry.startsWith("#")) continue;
                int separator = entry.indexOf('=');
                if (separator < 1) continue;
                String key = entry.substring(0, separator).trim();
                String value = entry.substring(separator + 1).trim();
                if (value.length() >= 2 && ((value.startsWith("\"") && value.endsWith("\"")) ||
                        (value.startsWith("'") && value.endsWith("'")))) {
                    value = value.substring(1, value.length() - 1);
                }
                values.put(key, value);
            }
        } catch (IOException e) {
            throw new IllegalStateException("Unable to read local .env configuration", e);
        }
        return values;
    }
}
