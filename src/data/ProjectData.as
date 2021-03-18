package data
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class ProjectData
    {
        public var file:File;
        public var name:String;
        public var date:Number;
        public var engine:String;

        public function ProjectData()
        {
        }

        public function save():void
        {
            // Saves data to file
            var u:Object = {meta: {}};
            u.meta.name = name;
            u.meta.date = date;
            u.meta.engine = engine;

            var fileStream:FileStream = new FileStream();
            fileStream.openAsync(file, FileMode.WRITE);
            fileStream.writeUTFBytes(JSON.stringify(u));
            fileStream.close();
        }

        public function remove():void
        {
            file.deleteFile();
            ProjectManager.instance.projects.removeItem(this);
            ProjectManager.instance.projects.refresh();
        }

        public function rename(value:String):void
        {
            name = value;
            var newFile:File = File.applicationStorageDirectory.resolvePath("projects").resolvePath(name + ".json");
            file.deleteFile();
            file = newFile;

            save();
            ProjectManager.instance.projects.refresh();
        }
    }
}
