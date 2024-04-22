from pytube import YouTube



def download_video(yt_video, out_path):

    yt = YouTube(yt_video)

    print(yt.title)
    print( yt.streams.filter(file_extension='mp4') )

    # first stream
    # stream1 = yt.streams[1]

    stream1 = yt.streams.filter(progressive=True, file_extension='mp4').order_by('resolution').desc().first()
    filename = stream1.download(output_path = out_path)

    print("video downloaded")
    print(filename)

    return filename

yt_video = "https://www.youtube.com/watch?v=eq2zQq2GtFQ"
out_path = "W:/GITHUB/AzureAI/downloaded/0001"

download_video(yt_video, out_path)