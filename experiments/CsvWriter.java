package com.smartstudy.experiments;

import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Tiny RFC-4180-flavoured CSV writer. No external dependency on purpose:
 * the experiment harness is meant to produce auditable files using only
 * the standard JDK + the project's existing dependencies.
 *
 * <p>Quoting rules:
 * <ul>
 *   <li>Cells that contain comma, double-quote, CR or LF are wrapped in
 *       double-quotes.</li>
 *   <li>Embedded double-quotes are escaped as {@code ""}.</li>
 *   <li>All other cells are written verbatim.</li>
 * </ul>
 */
public final class CsvWriter implements AutoCloseable {

    private final BufferedWriter writer;
    private final int expectedColumns;

    public CsvWriter(Path file, String... header) throws IOException {
        Files.createDirectories(file.getParent());
        this.writer = Files.newBufferedWriter(file, StandardCharsets.UTF_8);
        this.expectedColumns = header.length;
        writeRow((Object[]) header);
    }

    public void writeRow(Object... cells) throws IOException {
        if (cells.length != expectedColumns) {
            throw new IllegalArgumentException(
                    "CSV row width " + cells.length
                            + " does not match header width " + expectedColumns);
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < cells.length; i++) {
            if (i > 0) sb.append(',');
            sb.append(quote(cells[i]));
        }
        sb.append('\n');
        writer.write(sb.toString());
    }

    private static String quote(Object cell) {
        if (cell == null) return "";
        String text = cell.toString();
        boolean needsQuotes =
                text.indexOf(',') >= 0
                        || text.indexOf('"') >= 0
                        || text.indexOf('\n') >= 0
                        || text.indexOf('\r') >= 0;
        if (!needsQuotes) return text;
        return '"' + text.replace("\"", "\"\"") + '"';
    }

    @Override
    public void close() throws IOException {
        writer.flush();
        writer.close();
    }
}
