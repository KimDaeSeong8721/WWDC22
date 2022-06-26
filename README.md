# WWDC22

## 🍎 WWDC 2021 Swift Student Challenge Winner 🎉

##Difference between high tide and low tide

Before we start, please play it on the horizontal screen.

This app is an educational app designed to visually show high tide and low tide according to the relative positions of the sun, earth, and moon, and to show the difference between high and low tide.
When the sun, earth, and moon are in a straight line, the difference between tides is the greatest. This is because the tide-generating force
by the moon and the tide-generating force by the sun are added.
On the other hand, when the positions of the sun and the moon are placed vertically on the earth's basis, the difference between the tides is the smallest. This is because the tidal force by the moon affects high tide and the tidal force by the sun generally affects low tide.
And to make it simple, I set up some assumptions.

##assumptions

1. The person at the equator set the standard and caused high tide and low tide to occur twice a day.
2. It is assumed that the former is lower in this app, although the low tide is often higher when the moon is the first quarter moon or the last quarter moon than the low tide when the moon is the months or the full moon.
3. The relative size and location of the sun, earth, and moon were roughly set.

##Function

1. Press the Earth icon button to rotate the Earth and change the height of the sea level, the background of the sky, and the time.
2. If you press the moon icon button, the moon revolves around the Earth, and the height of the sea level in a high tide situation, and the shape of the moon seen from the Earth, change.
3. Tap the scale icon to display the scale, and you can determine the approximate height.
4. The sound of the sea is embodied.
5. Using Scenekit, the relative positions of the sun, earth, and moon were implemented as 3D images, and white spheres were overlapped to make human forms.

![IMG_0439](https://user-images.githubusercontent.com/69894461/171026517-de969237-fd26-4bc6-95c6-0d1af6ff9226.jpg)
