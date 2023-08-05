
void bellman_ford(int n, int *graph, int *dist) {
    // Initialization
    dist[0] = 0;
    for (int i = 1; i < n; i++) {
        dist[i] = -1;
    }

    // Relaxation for (n - 1) times
    for (int i = 1; i < n; i++) {
        // Relaxation on every edge each time
        for (int u = 0; u < n; u++) {
            for (int v = 0; v < n; v++) {
                int addr = (u << 5) + v;
                if (dist[u] == -1 || graph[addr] == -1)
                    continue;
                if (dist[v] == -1 || dist[v] > dist[u] + graph[addr]) {
                    dist[v] = dist[u] + graph[addr];
                }
            }
        }
    }
}
void show_number(int n) {
    for (;;) {
        for (int i = 0; i < 4; i++) {
            register int t = 0;
            t = t | 0b000100000000 << i;
            register int temp = (n >> ((3 - i) << 2)) & 0b1111;
            if (temp == 0)
                t |= 0b0111111;
            else if (temp == 1)
                t |= 0b0000110;
            else if (temp == 2)
                t |= 0b1011011;
            else if (temp == 3)
                t |= 0b1001111;
            else if (temp == 4)
                t |= 0b1100110;
            else if (temp == 5)
                t |= 0b1101101;
            else if (temp == 6)
                t |= 0b1111101;
            else if (temp == 7)
                t |= 0b0000111;
            else if (temp == 8)
                t |= 0b1111111;
            else if (temp == 9)
                t |= 0b1101111;
            else
                t |= 0;

            *(int *)(0x40000010) = t;
            for (int j = 0; j < 10000; j++) {
            }
        }
    }
}
void _start() {
    int *buffer = (int *)0;
    int *dist = (int *)0x200;
    int n = buffer[0];
    int *graph = (int *)(buffer + 1);

    // Bellman-Ford
    bellman_ford(n, graph, dist);
    int sum = 0;
    // Output
    for (int i = 1; i < n; i++) {
        sum += dist[i];
    }

    show_number(sum);
}
