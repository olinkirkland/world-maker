package data
{
    import com.fzip.FZip;
    import com.fzip.FZipFile;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;

    import mx.utils.UIDUtil;

    public class EngineData extends EventDispatcher
    {
        public static const DOWNLOADING:String = "downloading";
        public static const UNZIPPING:String = "unzipping";
        public static const CONTENT_READY:String = "contentReady";
        public static const UNINSTALL:String = "uninstall";

        public var version:String;
        public var url:String;
        public var date:Number;

        public var installDirectory:File;
        public var downloadingOrUnzipping:Boolean = false;

        function EngineData()
        {
        }

        public function download():void
        {
            downloadingOrUnzipping = true;

            trace("Downloading " + url);
            dispatchEvent(new Event(DOWNLOADING));

            setTimeout(startDownload, 200);
        }

        private function startDownload():void
        {
            // Check the target file and delete it if it exists
            var targetFile:File = File.applicationStorageDirectory.resolvePath("downloads/" + version + ".zip");
            if (targetFile.exists)
                targetFile.deleteFile();

            var urlStream:URLStream = new URLStream();
            var fileStream:FileStream = new FileStream();
            urlStream.load(new URLRequest(url + "?" + UIDUtil.createUID()));

            urlStream.addEventListener(ProgressEvent.PROGRESS, function (event:ProgressEvent):void
            {
                dispatchEvent(event);
                //trace((event.bytesLoaded / 1000).toFixed(1) + " KB / " + (event.bytesTotal / 1000).toFixed(1) + " KB");
            });

            urlStream.addEventListener(Event.COMPLETE, function (event:Event):void
            {
                var fileData:ByteArray = new ByteArray();
                urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
                fileStream.openAsync(targetFile, FileMode.WRITE);
                fileStream.writeBytes(fileData, 0, fileData.length);
                fileStream.close();

                setTimeout(function ():void
                {
                    unzipAndCopy(targetFile);
                }, 1000);
            });

            urlStream.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent):void
            {
                downloadingOrUnzipping = false;
                trace("Error! Not a valid address");
            });
        }

        private function unzipAndCopy(file:File):void
        {
            var targetDirectory:File = File.applicationStorageDirectory.resolvePath("versions/" + version);

            // Extract the contents of a zip file to the versions directory
            var zip:FZip = new FZip();
            zip.addEventListener(Event.COMPLETE, onUnzipComplete);

            trace("Unzipping " + file.nativePath);
            dispatchEvent(new Event(UNZIPPING));

            //zip.load(new URLRequest(file.nativePath));

            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.READ);
            var bytes:ByteArray = new ByteArray();
            stream.readBytes(bytes, 0, stream.bytesAvailable);
            stream.close();
            zip.loadBytes(bytes);

            function onUnzipComplete(e:Event):void
            {
                trace("Unzip complete");
                var fileStream:FileStream = new FileStream();
                var fileCount:int = zip.getFileCount();
                for (var i:int = 0; i < fileCount; i++)
                {
                    var extractedFile:FZipFile = zip.getFileAt(i);
                    var targetFile:File = targetDirectory.resolvePath(extractedFile.filename)

                    trace("Extracting " + extractedFile.filename + " to " + targetFile.nativePath);

                    fileStream.open(targetFile, FileMode.WRITE);
                    fileStream.writeBytes(extractedFile.content);
                    fileStream.close();
                }

                trace("Unzipping complete!")
                dispatchEvent(new Event(CONTENT_READY));
                EngineManager.instance.enginesChanged();
            }


            downloadingOrUnzipping = false;
        }

        public function uninstall():void
        {
            installDirectory.deleteDirectory(true);
            dispatchEvent(new Event(EngineData.UNINSTALL));
            EngineManager.instance.enginesChanged();
        }
    }
}
