package data
{
    import events.PopupEvent;

    import ui.popups.Popup;

    public class PopupManager
    {
        public static function open(popup:Popup):void
        {
            Signal.instance.dispatchEvent(new PopupEvent(PopupEvent.OPEN, popup));
        }

        public static function close():void
        {
            Signal.instance.dispatchEvent(new PopupEvent(PopupEvent.CLOSE));
        }
    }
}
