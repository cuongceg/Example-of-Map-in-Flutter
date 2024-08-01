# How to use this AnimatedIcon open_close
- First, thanks @Atomos-X for creating the file add_close.g.dart.It's wonderful and useful for me <33333333.
- Build your AnimatedIconData file (.g.dart) and copy it to the path [your path]/flutter/packages/flutter/lib/src/material/animated_icons/data. An example in [here](https://github.com/Atomos-X/Flutter_Animated_Icon_Data/blob/master/src/add_close.g.dart)
- add this line to file animated_icons_data.dart
```sh
static const AnimatedIconData add_close = _$add_close; 
```
- add this line to file animated_icons.dart(your_path/flutter/common/flutter/packages/flutter/lib/src/material/animated_icons.dart)
```sh
part 'animated_icons/data/add_close.g.dart';
```
