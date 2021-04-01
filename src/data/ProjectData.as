package data
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import ui.popups.PopupModifyProject;

    public class ProjectData
    {
        public var file:File;
        public var name:String;
        public var dateCreated:Number;
        public var dateModified:Number;
        public var engine:String;
        public var content:Object;

        public function ProjectData()
        {
        }

        public function save():void
        {
            // Saves data to file
            var u:Object = {meta: {}};
            u.meta.name = name;
            u.meta.dateCreated = dateCreated;
            u.meta.dateModified = dateModified;
            u.meta.engine = engine;
            u.content = content;

            var fileStream:FileStream = new FileStream();
            fileStream.openAsync(file, FileMode.WRITE);
            fileStream.writeUTFBytes(JSON.stringify(u, null, " "));
            fileStream.close();
        }

        public function remove():void
        {
            if (file.exists)
                file.deleteFile();
            else
                trace("Error! File does not exist so it cannot be deleted:\n  " + file.nativePath);
            ProjectManager.instance.projects.removeItem(this);
            ProjectManager.instance.projects.refresh();
        }

        public function modify(popup:PopupModifyProject):void
        {
            name = popup.selectedName;
            dateModified = new Date().time;
            engine = popup.selectedEngine.version;

            var newFile:File = File.applicationStorageDirectory.resolvePath("projects").resolvePath(name + ".json");
            file.deleteFile();
            file = newFile;

            save();
            ProjectManager.instance.projects.refresh();
        }
    }
}
