# Feathers Release Notes

Noteworthy changes in official releases of [Feathers](http://feathersui.com/).

## 1.1.1

This release includes minor updates to support Starling Framework 1.4 and a few
minor bug fixes.

* Switches to Starling's implementation of the `clipRect` property.
* Uses Texture onRestore for internally managed textures, like in text controls.
* StageTextTextEditor: fix for displayAsPassword clearing the text.
* Panel: won't scroll if mouse wheel or touch occurs in header or footer.
* Panel: header and footer can be touched when content is scrolling.
* AeonDesktopTheme: uses a better disabled text color.
* SmartDisplayObjectStateValueSelector: properly supports uint color value of 0.
* Item Renderers: smarter handling of accessory resizing.
* Item Renderers: better measurement to account for NaN.
* Item Renderers: properly checks for _data, in addition to _owner, in commitData().
* Label: sets proper text renderer dimensions if height is explicitly set.
* Radio: better handling of setting toggleGroup to avoid accidentally adding to defaultRadioGroup.
* Scroller: properly updates isEnabled on scroll bars when they are first created.
* Scroller: child touches are blocked until throw animation finishes to match native behavior.
* Scroll bars: better isEnabled handling.
* TextInput: better handling of focus when not visible.
* TextInput: better prompt handling.
* TextFieldTextEditor: snapshot is properly hidden when text is cleared.
* ButtonGroup: properly resizes when data provider changes.
* GroupedList: requests proper typical item from data provider.
* ScrollText: better padding getter.
* PickerList: closes pop-up list on Event.TRIGGERED.
* PickerList: properly disposes pop-up list and IPopUpContentManager.
* TiledRowsLayout, TiledColumnsLayout: fixed manageVisibility implementation.
* TiledRowsLayout, TiledColumnsLayout: fixed bad positioning when useSquareTiles is true.

## 1.1.0

* New Beta Component: NumericStepper. Add and subtract from a numeric value with buttons. Optional text editing.
* New Beta Component: TextArea. A multiline text input. Recommended for desktop only. Not recommended for mobile.
* New Beta Component: Panel. A new container subclassing ScrollContainer that adds a header and an optional footer.
* New Beta Component: PanelScreen. An IScreen implementation (similar to Screen) based on Panel.
* New Beta Layout: AnchorLayout. Added to support fluid layouts and relative positioning. Can position relative to parent container and also to other children of the parent container.
* Added FocusManager for keyboard navigation and interaction. Not intended for mobile. Use a desktop theme or set `FocusManager.isEnabled = true`. TextInput *cannot* use StageTextTextEditor when focus management is enabled. TextFieldTextEditor is recommended.
* All Components: sub-components are created from factories and can receive custom names for theming.
* Added ILayoutObject interface to support extra data for layouts to use, like includeInLayout property.
* List: support for optional multiple selection.
* TextInput: supports prompt/hint
* TextInput/StageTextTextEditor: supports multiline on mobile.
* PickerList: supports prompt when no item is selected.
* Slider: measurement now includes thumb dimensions and a new property called trackScaleMode has been added.
* Callout: disposal is more consistent. Set combination of disposeOnSelfClose and disposeContent.
* Callout: doesn't close when origin is touched. origin should now separately determine correct behavior.
* Callout: added origin and supportedDirections properties to make Callout capable of switching origins after creation.
* Item Renderers: properly handle accessory resizing if accessory is a FeathersControl.
* Item Renderers: fixes for a number of layout order, gap, and alignment combinations.
* PickerList: doesn't close when touching scroll bar. only item renderer touch will trigger a close.
* PopUpManager: Supports custom root to place pop-ups somewhere other than the stage.
* PopUpManager: modal pop-ups receive a different focus manager.
* ScreenNavigator: added hasScreen(), getScreen(), and getScreenIDs().
* ScreenNavigator: added autoSizeMode property to select between sizing to fit stage or to fit content.
* ScreenNavigator: fix for broken transition if showScreen() is calleed before transition begins but after new screen is added to stage.
* Transitions: fix for quickStack constructor argument.
* ScrollContainer, List, GroupedList: better auto-sizing with a background skin.
* ScrollContainer: new alternate name for toolbar style.
* TextInput: exposed isEditable, maxChars, restrict, and displayAsPassword properties.
* BitmapFontTextRenderer, Scale3Image, Scale9Image: option to turn off the use of a separate QuadBatch.
* TextFieldTextEditor: better selection on mobile.
* TextFieldTextEditor: properly dispatches FeathersEventType.ENTER.
* Text Renderers and Editors: better snapshot disposal.
* TextFieldTextRenderer: better measurement to workaround runtime dimensions being wrong.
* TiledRowsLayout, TiledColumnsLayout: supports separate horizontal and vertical gaps.
* TiledRowsLayout, TiledColumnsLayout: more stable virtualized item renderer count to improve performance.
* TiledRowsLayout, TiledColumnsLayout: fixes for certain issues with paging.
* ButtonGroup: supports isEnabled as a property in the data provider.
* ImageLoader: added delayTextureCreation flag to avoid creating textures while scrolling (or during any action that requires best performance).
* Scroller: adds an invisible overlay during scrolling to block touch events on children.
* Scroller: exposes horizontal and vertical page count properties.
* Scroller: added FeathersEventType.SCROLL_START event.
* Scroller: scroll bars are hidden when stopScrolling() is called.
* Scroller: fix for velocity calculation.
* Button: better detection of click to avoid other display objects moving on top of button before TouchPhase.ENDED.
* Button: new styles for themes, including back, forward, call-to-action, quiet, and danger.
* List: if items are added or removed, selected indices are adjusted.
* List, GroupedList, ScrollContainer, and ScrollText all extend Scroller, instead of using it as a sub-component. The scrollerProperties property on each of these is now deprecated because all public properties of Scroller are now direct public properties of these components. Theme initializers that target Scroller will break because Scroller is no longer a sub-component, but a super class of classes like List. Move this stuff into initializers for List, GroupedList, ScrollContainer, and ScrollText.
* FeathersControl: setSizeInternal() is now stricter. It can never receive a NaN value for width or height. This is a common source of bugs, and throwing an error here will help make it easier to find those bugs.
* IVariableVirtualLayout: added function addToVariableVirtualCacheAtIndex() for more specific control over the cache of item dimensions. The following implementation can be added to existing classes to simulate the old behavior:

<!--- markdown is failing miserably. I'll take separate lists over inconsistent formatting -->

```
public addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
{
	this.resetVariableVirtualCache();
}
```
* IVariableVirtualLayout: added function removeFromVariableVirtualCacheAtIndex() for more specific control over the cache of item dimensions. The following implementation can be added to existing classes to simulate the old behavior:

```
public removeFromVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
{
	this.resetVariableVirtualCache();
}
```
* ScrollText: now properly handles visible and alpha properties.
* ListCollection: added removeAll(), addAll(), addAllAt() and contains().
* Scroller: scrolling animates for mouse wheel.
* List, VerticalLayout, HorizontalLayout: optimized case where useVirtualLayout is true and hasVariableItemDimensions is false.
* HorizontalLayout, VerticalLayout, TiledRowsLayout, TiledColumnsLayout: added manageVisibility property to set items to false when not in view. Set to true to improve performance.
* Item Renderers: added stopScrollingOnAccessoryTouch property to make accessory touch behavior configurable.
* Screen: default value of originalDPI is DeviceCapabilities.dpi. It used to be 168. Can still be changed.
* MetalWorksMobileTheme and MinimalMobileTheme: major overhaul with improved skins and new alternate skins.
* AeonDesktopTheme: added some missing skins, like TabBar.
* AeonDesktopTheme: uses FocusManager.
* AzureMobileTheme: removed this example theme. Please feel free to continue using the old version, if desired.
* ComponentsExplorer: better button screen to show off various styles of buttons.
* Todos: new example.
* All Examples: Use PanelScreen instead of Screen and Header where appropriate.
* All Examples: Use AnchorLayout where appropriate.
* All Examples: Uses NumericStepper instead of Slider where appropriate.
* Added 96x96 icons to examples for Android xhdpi. Requires AIR 3.7.
* Extended API documentation with inline examples and improved descriptions.
* Added many new articles to the Feathers Manual.
* Now built with ASC 2.0.

## 1.0.1

This release includes a number of bug fixes.

* Scroller: FeathersEventType.SCROLL_COMPLETE always dispatched after last Event.SCROLL.
* ScrollBar, SimpleScrollBar: thumb position properly accounts for padding.
* Scroller: mouse wheel detection properly accounts for contentScaleFactor.
* ScreenNavigator: calling clearScreen() during a transition no longer causes a stack overflow.
* ScrollBar, SimpleScrollBar: can drag to minimum and maximum if they aren't a multiple of the step.
* Header: Fix for runtime error when rightItems aren't IFeathersDisplayObjects
* TextInput: better selection/cursor recovery when changing text programmatically.
* TextInput: Moved fontSize contentScaleFactor multiplication into StageTextTextEditor.
* FeathersControl: requires isInitialized to be true before it can validate.
* FeathersControl: clipRect properly accounts for scale.
* GroupedList: added missing documentation for setSelectedLocation().
* ImageLoader: does a better job keeping aspect ratio when only one dimension is explicit.
* ImageLoader: properly scales content when dimensions are explicit.
* ImageLoader: no runtime errors if content loads after dispose.
* ScrollContainer, List, GroupedList, ScrollText: fix for detecting changes in scrollToPageIndex().

## 1.0.0

No major API changes since 1.0.0 BETA. Mostly bug fixes and minor improvements.

* Fix for memory leaks in List, GroupedList, and ImageLoader
* PageIndicator properly handles ImageLoader or other IFeathersControl as symbol
* IGroupedListHeaderOrFooterRenderer extends IFeathersControl
* Header: fix for "middle" vertical alignment
* Updated for Starling Framework 1.3

## 1.0.0 BETA

Initial release. The following major changes happened in the last month or two leading to the beta.

* GTween library removed as a dependency. All animations switched to the Starling `Tween` class.
* as3-signals library removed as a dependency. Switched to Starling events.
* `TextInput`: supports swappable text editors, similar to the text renderers used for uneditable text. The default `StageTextTextEditor` uses `StageText` to allow text input, which is ideal for mobile. The `TextFieldTextEditor` uses a `TextField` of `TextFieldType.INPUT` instead, and it may be a better choice for desktop. A static function, `defaultTextEditorFactory`, has been added to `FeathersControl`.
* `TextInput`: now has events for focus in and out.
* Item renderers: Switched to `ImageLoader` for icon and accessory textures, which has a `source` property that supports `Texture` instances or `String` URLs to load textures from the web. Properties like `iconTextureField` and `accessoryTextureFunction` now have new names like `iconSourceField` and `accessorySourceFunction` because values other than textures are now allowed. Similarly, `iconImageFactory` and `accessoryImageFactory` have been renamed to `iconLoaderFactory` and `accessoryLoaderFactory`.
* Item renderers: accessory may be positioned. See `layoutOrder` and `accessoryPosition` properties.
* Added `dispose()` method to `AddedWatcher` so that theme resources like textures be disposed.
* Added `ScrollText` component to display text in an overlay on the native display list. Useful for long passages of text that may be too large to convert to a texture.
* `ScreenNavigator`: added events for transition start and complete.
* `ToggleSwitch`: `TRACK_LAYOUT_MODE_STRETCH` is now `TRACK_LAYOUT_MODE_ON_OFF`.
* `Slider`: `TRACK_LAYOUT_MODE_STRETCH` is now `TRACK_LAYOUT_MODE_MIN_MAX`.
* `ScrollBar`: `TRACK_LAYOUT_MODE_STRETCH` is now `TRACK_LAYOUT_MODE_MIN_MAX`.
