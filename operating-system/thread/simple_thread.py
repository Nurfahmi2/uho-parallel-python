import threading
import time

# Fungsi yang akan dijalankan dalam thread
def worker(thread_name):
    print(f'Thread {thread_name} mulai bekerja, read 1 million row from DB {thread_name}')
    time.sleep(2)  # Simulasi pekerjaan yang memakan waktu
    print(f'Thread {thread_name} selesai.')

# Membuat thread
thread1 = threading.Thread(target=worker, args=('A',))
thread2 = threading.Thread(target=worker, args=('B',))

# Memulai thread
thread1.start()
thread2.start()