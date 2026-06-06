package com.smartstudy.experiments;

import java.util.Arrays;
import java.util.List;

/**
 * Hand-rolled statistics helpers used by the {@link ExperimentRunner}.
 * The harness is intentionally dependency-free: every figure that ends
 * up in the paper can be audited by reading these few methods.
 */
public final class Statistics {

    private Statistics() {}

    public static double mean(double[] xs) {
        if (xs == null || xs.length == 0) return 0.0;
        double s = 0.0;
        for (double x : xs) s += x;
        return s / xs.length;
    }

    public static double populationStdDev(double[] xs) {
        if (xs == null || xs.length == 0) return 0.0;
        double m = mean(xs);
        double s = 0.0;
        for (double x : xs) s += (x - m) * (x - m);
        return Math.sqrt(s / xs.length);
    }

    public static double sampleStdDev(double[] xs) {
        if (xs == null || xs.length < 2) return 0.0;
        double m = mean(xs);
        double s = 0.0;
        for (double x : xs) s += (x - m) * (x - m);
        return Math.sqrt(s / (xs.length - 1));
    }

    public static double min(double[] xs) {
        if (xs == null || xs.length == 0) return 0.0;
        double v = xs[0];
        for (double x : xs) if (x < v) v = x;
        return v;
    }

    public static double max(double[] xs) {
        if (xs == null || xs.length == 0) return 0.0;
        double v = xs[0];
        for (double x : xs) if (x > v) v = x;
        return v;
    }

    /** NumPy-style linear-interpolation percentile, p in [0, 100]. */
    public static double percentile(double[] xs, double p) {
        if (xs == null || xs.length == 0) return 0.0;
        double[] s = Arrays.copyOf(xs, xs.length);
        Arrays.sort(s);
        if (s.length == 1) return s[0];
        double rank = (p / 100.0) * (s.length - 1);
        int lo = (int) Math.floor(rank);
        int hi = (int) Math.ceil(rank);
        if (lo == hi) return s[lo];
        double frac = rank - lo;
        return s[lo] * (1 - frac) + s[hi] * frac;
    }

    public static double median(double[] xs) { return percentile(xs, 50.0); }

    /**
     * Pearson correlation coefficient. Returns 0 on degenerate inputs.
     */
    public static double pearson(double[] xs, double[] ys) {
        if (xs == null || ys == null || xs.length != ys.length || xs.length == 0) return 0.0;
        double mx = mean(xs), my = mean(ys);
        double num = 0, dx = 0, dy = 0;
        for (int i = 0; i < xs.length; i++) {
            double a = xs[i] - mx, b = ys[i] - my;
            num += a * b; dx += a * a; dy += b * b;
        }
        double denom = Math.sqrt(dx * dy);
        return denom == 0.0 ? 0.0 : num / denom;
    }

    /**
     * Spearman rank-order correlation — Pearson on rank-transformed inputs.
     */
    public static double spearman(double[] xs, double[] ys) {
        if (xs == null || ys == null || xs.length != ys.length || xs.length == 0) return 0.0;
        return pearson(rank(xs), rank(ys));
    }

    private static double[] rank(double[] xs) {
        int n = xs.length;
        Integer[] idx = new Integer[n];
        for (int i = 0; i < n; i++) idx[i] = i;
        Arrays.sort(idx, (a, b) -> Double.compare(xs[a], xs[b]));
        double[] r = new double[n];
        int i = 0;
        while (i < n) {
            int j = i;
            while (j + 1 < n && xs[idx[j + 1]] == xs[idx[i]]) j++;
            double avg = (i + j) / 2.0 + 1.0;
            for (int k = i; k <= j; k++) r[idx[k]] = avg;
            i = j + 1;
        }
        return r;
    }

    /**
     * Cohen's d effect size between two samples (pooled standard deviation).
     */
    public static double cohensD(double[] a, double[] b) {
        if (a == null || b == null || a.length < 2 || b.length < 2) return 0.0;
        double ma = mean(a), mb = mean(b);
        double va = 0, vb = 0;
        for (double x : a) va += (x - ma) * (x - ma);
        for (double x : b) vb += (x - mb) * (x - mb);
        va /= (a.length - 1);
        vb /= (b.length - 1);
        double pooled = Math.sqrt(((a.length - 1) * va + (b.length - 1) * vb)
                / (a.length + b.length - 2));
        return pooled == 0.0 ? 0.0 : (ma - mb) / pooled;
    }

    /**
     * Paired t-statistic of (a[i] - b[i]) > 0. Caller can compare against
     * t-table values; we report the magnitude.
     */
    public static double pairedT(double[] a, double[] b) {
        if (a == null || b == null || a.length != b.length || a.length < 2) return 0.0;
        double[] d = new double[a.length];
        for (int i = 0; i < a.length; i++) d[i] = a[i] - b[i];
        double md = mean(d);
        double sd = sampleStdDev(d);
        if (sd == 0.0) return 0.0;
        return md / (sd / Math.sqrt(d.length));
    }

    /** Bucket the values into {@code bins} equal-width bins spanning [lo, hi]. */
    public static int[] histogram(double[] xs, int bins, double lo, double hi) {
        int[] counts = new int[Math.max(1, bins)];
        if (xs == null || xs.length == 0 || hi <= lo) return counts;
        double width = (hi - lo) / bins;
        for (double x : xs) {
            if (x < lo || x > hi) continue;
            int b = (int) Math.floor((x - lo) / width);
            if (b == bins) b = bins - 1;
            counts[b]++;
        }
        return counts;
    }

    public static double[] toArray(List<? extends Number> list) {
        double[] out = new double[list.size()];
        for (int i = 0; i < list.size(); i++) out[i] = list.get(i).doubleValue();
        return out;
    }
}
