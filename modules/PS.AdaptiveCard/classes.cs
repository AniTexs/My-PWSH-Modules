namespace PS.AdaptiveCard
{
    using System;
    using System.Collections.Generic;

    // -------------------------
    // Shared building blocks
    // -------------------------

    public abstract class CardObject
    {
        // Common across many schema objects
        public string id { get; set; }
        public bool? isVisible { get; set; }

        // Adaptive Cards "requires" (feature requirement map)
        public Dictionary<string, string> requires { get; set; }

        // fallback can be "drop" or another element/action depending on context
        public object fallback { get; set; }
    }

    public abstract class Element : CardObject
    {
        // Base element properties (common in many elements)
        public Layout.Spacing? spacing { get; set; }
        public bool? separator { get; set; }
        public Layout.Height? height { get; set; }
        public string minHeight { get; set; } // often "string" in schema (e.g. "50px")
        public bool? bleed { get; set; }
    }

    public abstract class ActionBase : CardObject
    {
        public string title { get; set; }
        public Uri iconUrl { get; set; }

        public Action.ActionStyle? style { get; set; }
        public Action.ActionMode? mode { get; set; }

        // Action-level enabled/visible expressions exist in later schema versions
        public object isEnabled { get; set; }
        public bool? isPrimary { get; set; }
    }

    // -------------------------
    // Enums you already started
    // -------------------------

    // Element Specific Styles
    public class Badge
    {
        public enum Styles
        {
            Default, Subtle, Informative, Accent, Good, Attention, Warning
        }

        public enum Shape
        {
            Default, Circular, Rounded
        }

        public enum Size
        {
            Medium, Large, ExtraLarge
        }
    }

    public class Button
    {
        public enum Styles
        {
            Default, Positive, Destructive
        }

        public enum Mode
        {
            Primary, Secondary
        }
    }

    public class Action : Button
    {
        public enum ActionStyle
        {
            Default,
            Positive,
            Destructive
        }

        public enum ActionMode
        {
            Primary,
            Secondary
        }

        public enum Type
        {
            Submit,
            OpenUrl,
            Execute,
            ToggleVisibility,
            ShowCard
        }
    }

    public class Code
    {
        public enum Language
        {
            Bash, C, Cpp, CSharp, CSS, Dos, Go, Graphql, Html, Java, JavaScript, Json, ObjectiveC, Perl, Php, PlainText, PowerShell, Python, Sql, TypeScript, VbNet, Verilog, Vhdl, Xml
        }
    }

    // Font Styles
    public class Text
    {
        public enum BaseStyle
        {
            Default, Heading, ColumnHeader
        }

        public enum FontType
        {
            Default, Monospace
        }

        public enum FontSize
        {
            Small, Default, Medium, Large, ExtraLarge
        }

        public enum FontWeight
        {
            Lighter, Default, Bolder
        }

        public enum FontColor
        {
            Default, Dark, Light, Accent, Good, Warning, Attention
        }

        public enum HorizontalAlignment
        {
            Left, Center, Right
        }
    }

    // Layout Enums
    public class Layout
    {
        public enum Spacing
        {
            None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding
        }

        public enum VerticalAlignment
        {
            Top, Center, Bottom
        }

        public enum HorizontalAlignment
        {
            Left, Center, Right
        }

        public enum Height
        {
            Auto, Stretch
        }

        public enum ContainerStyle
        {
            Default,
            Emphasis,
            Good,
            Attention,
            Warning,
            Accent
        }
    }

    // -------------------------
    // AdaptiveCard (root)
    // -------------------------

    public class AdaptiveCard : CardObject
    {
        public string type { get; set; } = "AdaptiveCard";

        // Schema
        public string version { get; set; } // e.g. "1.5"
        public string schema { get; set; }  // "$schema" in JSON; keep simple

        public string lang { get; set; }
        public string speak { get; set; }

        public BackgroundImage backgroundImage { get; set; }
        public Layout.ContainerStyle? style { get; set; }

        public List<Element> body { get; set; }
        public List<ActionBase> actions { get; set; }

        // Newer properties (optional)
        public object refresh { get; set; }
        public object authentication { get; set; }
        public object metadata { get; set; }
    }

    // -------------------------
    // BackgroundImage
    // -------------------------

    public class BackgroundImage
    {
        public Uri url { get; set; }
        public string fillMode { get; set; } // "cover", "repeatHorizontally", etc. (host-dependent)
        public string horizontalAlignment { get; set; } // "left|center|right"
        public string verticalAlignment { get; set; }   // "top|center|bottom"
    }

    // -------------------------
    // TextBlock
    // -------------------------

    public class TextBlock : Element
    {
        public string type { get; set; } = "TextBlock";

        public string text { get; set; }
        public bool? wrap { get; set; }
        public int? maxLines { get; set; }

        public Text.FontSize? size { get; set; }
        public Text.FontWeight? weight { get; set; }
        public Text.FontColor? color { get; set; }

        public bool? subtle { get; set; }
        public Text.HorizontalAlignment? horizontalAlignment { get; set; }

        public bool? isSubtle { get; set; } // some hosts use this naming
        public string fontType { get; set; } // "Default" / "Monospace" (kept string to avoid host variance)

        public Layout.Spacing? spacingOverride { get; set; }
    }

    // -------------------------
    // Image
    // -------------------------

    public class Image : Element
    {
        public string type { get; set; } = "Image";

        public Uri url { get; set; }
        public string altText { get; set; }

        public string size { get; set; } // "auto|stretch|small|medium|large" (host-dependent)
        public Text.HorizontalAlignment? horizontalAlignment { get; set; }

        public string backgroundColor { get; set; }
        public string style { get; set; } // "default|person" (depending on schema version)
        public bool? selectActionDisabled { get; set; }

        public ActionBase selectAction { get; set; } // ISelectAction in docs; model as ActionBase
    }

    // -------------------------
    // Media, MediaSource, CaptionSource
    // -------------------------

    public class Media : Element
    {
        public string type { get; set; } = "Media";

        public List<MediaSource> sources { get; set; }
        public List<CaptionSource> captionSources { get; set; }

        public string poster { get; set; } // URL string in schema (can be uri)
        public string altText { get; set; }
    }

    public class MediaSource
    {
        public string mimeType { get; set; }
        public Uri url { get; set; }
    }

    public class CaptionSource
    {
        public string mimeType { get; set; }
        public Uri url { get; set; }
        public string label { get; set; }
    }

    // -------------------------
    // RichTextBlock, TextRun
    // -------------------------

    public class RichTextBlock : Element
    {
        public string type { get; set; } = "RichTextBlock";

        public List<TextRun> inlines { get; set; }

        public Text.HorizontalAlignment? horizontalAlignment { get; set; }
    }

    public class TextRun
    {
        public string type { get; set; } = "TextRun";

        public string text { get; set; }
        public bool? italic { get; set; }
        public bool? strikethrough { get; set; }
        public bool? underline { get; set; }

        public Text.FontSize? size { get; set; }
        public Text.FontWeight? weight { get; set; }
        public Text.FontColor? color { get; set; }

        public bool? subtle { get; set; }

        public ActionBase selectAction { get; set; }
        public string highlight { get; set; }
    }

    // -------------------------
    // ActionSet
    // -------------------------

    public class ActionSet : Element
    {
        public string type { get; set; } = "ActionSet";

        public List<ActionBase> actions { get; set; }
    }

    // -------------------------
    // Container
    // -------------------------

    public class Container : Element
    {
        public string type { get; set; } = "Container";

        public List<Element> items { get; set; }

        public Layout.ContainerStyle? style { get; set; }
        public BackgroundImage backgroundImage { get; set; }

        public Layout.VerticalAlignment? verticalContentAlignment { get; set; }

        public ActionBase selectAction { get; set; }
    }

    // -------------------------
    // ColumnSet, Column
    // -------------------------

    public class ColumnSet : Element
    {
        public string type { get; set; } = "ColumnSet";

        public List<Column> columns { get; set; }

        public Layout.ContainerStyle? style { get; set; }
        public ActionBase selectAction { get; set; }
    }

    public class Column : Element
    {
        public string type { get; set; } = "Column";

        public List<Element> items { get; set; }

        public object width { get; set; } // "auto" | "stretch" | number
        public BackgroundImage backgroundImage { get; set; }
        public Layout.ContainerStyle? style { get; set; }

        public Layout.VerticalAlignment? verticalContentAlignment { get; set; }

        public ActionBase selectAction { get; set; }
    }

    // -------------------------
    // FactSet, Fact
    // -------------------------

    public class FactSet : Element
    {
        public string type { get; set; } = "FactSet";

        public List<Fact> facts { get; set; }
    }

    public class Fact
    {
        public string title { get; set; }
        public string value { get; set; }
    }

    // -------------------------
    // Table, TableCell (and supporting row/column)
    // -------------------------

    public class Table : Element
    {
        public string type { get; set; } = "Table";

        public List<TableColumnDefinition> columns { get; set; }
        public List<TableRow> rows { get; set; }

        public bool? showGridLines { get; set; }
        public Layout.ContainerStyle? gridStyle { get; set; }
        public Layout.ContainerStyle? firstRowAsHeadersStyle { get; set; }
    }

    public class TableColumnDefinition
    {
        public object width { get; set; } // number or "auto"/"stretch"
    }

    public class TableRow
    {
        public List<TableCell> cells { get; set; }
        public Layout.ContainerStyle? style { get; set; }
    }

    public class TableCell
    {
        public string type { get; set; } = "TableCell";

        public List<Element> items { get; set; }
        public Layout.ContainerStyle? style { get; set; }

        public int? rowSpan { get; set; }
        public int? columnSpan { get; set; }

        public Layout.VerticalAlignment? verticalContentAlignment { get; set; }
    }

    // -------------------------
    // ImageSet
    // -------------------------

    public class ImageSet : Element
    {
        public string type { get; set; } = "ImageSet";

        public List<Image> images { get; set; }
        public string imageSize { get; set; } // "small|medium|large" etc.
    }

    // -------------------------
    // Actions: OpenUrl, Submit, ShowCard, ToggleVisibility, Execute
    // -------------------------

    public class ActionOpenUrl : ActionBase
    {
        public string type { get; set; } = "Action.OpenUrl";
        public Uri url { get; set; }
    }

    public class ActionSubmit : ActionBase
    {
        public string type { get; set; } = "Action.Submit";

        public object data { get; set; }  // any
        public string associatedInputs { get; set; } // "auto" or "none" etc. depending on schema
    }

    public class ActionShowCard : ActionBase
    {
        public string type { get; set; } = "Action.ShowCard";
        public AdaptiveCard card { get; set; }
    }

    public class ActionToggleVisibility : ActionBase
    {
        public string type { get; set; } = "Action.ToggleVisibility";
        public List<TargetElement> targetElements { get; set; }
    }

    public class ActionExecute : ActionBase
    {
        public string type { get; set; } = "Action.Execute";

        public object verb { get; set; } // string typically
        public object data { get; set; } // any
    }

    public class TargetElement
    {
        public string elementId { get; set; }
        public bool? isVisible { get; set; }
    }

    // -------------------------
    // Inputs: Text, Number, Date, Time, Toggle, ChoiceSet, Choice
    // -------------------------

    public abstract class InputBase : Element
    {
        public string label { get; set; } // added for accessibility in newer versions
        public bool? isRequired { get; set; }
        public string errorMessage { get; set; }
    }

    public class InputText : InputBase
    {
        public string type { get; set; } = "Input.Text";

        public string value { get; set; }
        public string placeholder { get; set; }
        public bool? isMultiline { get; set; }
        public int? maxLength { get; set; }

        public string style { get; set; } // "text|tel|url|email|password" etc.
        public bool? inlineActionDisabled { get; set; }
        public ActionBase inlineAction { get; set; }
    }

    public class InputNumber : InputBase
    {
        public string type { get; set; } = "Input.Number";

        public double? value { get; set; }
        public double? min { get; set; }
        public double? max { get; set; }
        public string placeholder { get; set; }
    }

    public class InputDate : InputBase
    {
        public string type { get; set; } = "Input.Date";

        public string value { get; set; } // ISO date string
        public string min { get; set; }
        public string max { get; set; }
        public string placeholder { get; set; }
    }

    public class InputTime : InputBase
    {
        public string type { get; set; } = "Input.Time";

        public string value { get; set; } // "HH:mm"
        public string min { get; set; }
        public string max { get; set; }
        public string placeholder { get; set; }
    }

    public class InputToggle : InputBase
    {
        public string type { get; set; } = "Input.Toggle";

        public string title { get; set; }

        public string valueOn { get; set; } = "true";
        public string valueOff { get; set; } = "false";

        public string value { get; set; } // current value
        public bool? wrap { get; set; }
    }

    public class InputChoiceSet : InputBase
    {
        public string type { get; set; } = "Input.ChoiceSet";

        public List<InputChoice> choices { get; set; }

        public bool? isMultiSelect { get; set; }
        public string value { get; set; } // comma-separated for multi-select
        public string placeholder { get; set; }

        public string style { get; set; } // "compact|expanded|filtered" depending on schema/host
    }

    public class InputChoice
    {
        public string title { get; set; }
        public string value { get; set; }
    }

    // -------------------------
    // DataQuery
    // -------------------------

    public class DataQuery
    {
        public string type { get; set; } = "Data.Query";
        public string dataset { get; set; }
        public string count { get; set; }
        public string skip { get; set; }
    }
}
