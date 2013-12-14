Gesture-Recognition-1
=====================

The latest version is in Gesture-Recognition-2, with more predefined gestures and more accurate results. Feel free to download and try it out, enjoy~

###To use the code:

> **gesture_recognition9** is the main program

> **gesture_recognition10** is used to get the trained data from template images, the variables **fingerroot** and **fingerroot_var** are needed in gesture_recognition 9.

###functions explanations:

> **edge_finger** and **edge_connector** are used to detect the contour of the hand gesture and connect these pixels one by one.

> **center_finger** is used to find the centroid of the hand using distance transform

> **direction_detector1** is used to find the direction of the hand gesture because we need a reference point that is relatively fixed among all hand gestures for the ensuing steps

>**direction_detector3** is used to detect the direction of each finger which is used to determine the accurate direction of hand gesture.

> **start_end_points** finds the two contour points that are perpendicular to the direction of the hand. Because we think the points below them contribute less to the direction than the points above them. Thus we can use the points above them to again accurately determine the direction of the hand gesture.

> **trans_graph1** transfer the hand gesture into a *time-series curve*. The x-axis is the degree between each centour point and the reference point relative to the centroid, and the y-axis is the normalized distance between the contour points and the centroid.

>**finger_finger1** find the fingertip and the fingerroots of each unfold finger. This is used as the feature for recognition 

>**finger_finger3** is used to locate the accurate positions of fingerroots using the ratio between the area of the finger and its corresponding external rectangle. This ratio should surpass a certain threshold.
