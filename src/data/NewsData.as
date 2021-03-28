package data
{
    public class NewsData
    {
        public var title:String;
        public var content:Array;
        public var date:Number;

        public function NewsData()
        {
        }

        public function getImage():String
        {
            // Returns first image url in content
            for each (var section:NewsSectionData in content)
                if (section.type == NewsSectionType.IMAGE)
                    return section.url;

            return null;
        }

        public function getText():String
        {
            // Returns first text in content
            for each (var section:NewsSectionData in content)
                if (section.type == NewsSectionType.TEXT)
                    return section.text;

            return null;
        }
    }
}
