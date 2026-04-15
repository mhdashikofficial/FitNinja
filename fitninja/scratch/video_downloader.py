import yt_dlp
import os

videos = {
    "jab": "https://www.youtube.com/watch?v=1xNByPpsv-k",
    "cross": "https://www.youtube.com/watch?v=l_a6_1nkaRI",
    "hook": "https://www.youtube.com/watch?v=RIsfE1tE0eU",
    "defense": "https://www.youtube.com/watch?v=yP4SshM3r1A"
}

output_path = "assets/videos"

if not os.path.exists(output_path):
    os.makedirs(output_path)

ydl_opts = {
    'format': 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best',
    'outtmpl': os.path.join(output_path, '%(title)s.%(ext)s'),
    'quiet': False,
    'no_warnings': True,
}

for name, url in videos.items():
    print(f"Downloading {name} from {url}...")
    try:
        # Override output template per file for consistency
        opts = ydl_opts.copy()
        opts['outtmpl'] = os.path.join(output_path, f"{name}.%(ext)s")
        
        with yt_dlp.YoutubeDL(opts) as ydl:
            ydl.download([url])
            print(f"Successfully downloaded {name}.mp4")
    except Exception as e:
        print(f"Error downloading {name}: {e}")
