public class Main {
    static byte[] hold; // simulate a leak

    static long usedMB() {
        var rt = Runtime.getRuntime();
        return (rt.totalMemory() - rt.freeMemory()) / (1024 * 1024);
    }

    public static void main(String[] args) throws Exception {
        System.out.println("Used MB start:  " + usedMB());

        byte[][] arr = new byte[100][];
        for (int i = 0; i < 100; i++) arr[i] = new byte[1_000_000];
        System.out.println("After alloc:     " + usedMB() + " MB");

        arr = null;
        System.gc(); Thread.sleep(200);
        System.out.println("After GC hint:   " + usedMB() + " MB");

        hold = new byte[50_000_000];
        System.out.println("With held ref:   " + usedMB() + " MB");
    }
}
