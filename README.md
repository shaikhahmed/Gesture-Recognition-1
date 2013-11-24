###To use the code:

> **gesture_recognition8** is the main program

> **gesture_recognition10** is used to get the trained data from template images, the variables **fingeredge** and **fingeredge_var** are needed in gesture_recognition 7

###functions explanations:

> **edge__finger** and **edge__connector** are used to detect the contour of the hand gesture and connect these pixels one by one.

> **center_finger** is used to find the centroid of the hand using distance transform

> **direction_detector1** is used to find the direction of the hand gesture because we need a reference point that is relatively fixed among all hand gestures for the ensuing steps

> **start_end_points** finds the two contour points that are perpendicular to the direction of the hand. Because we think the points below them contribute less to the direction than the points above them. Thus we can use the points above them to again accurately determine the direction of the hand gesture.

> **trans_graph1** transfer the hand gesture to a polar graph with the contour-centroid-reference_point degree as the x-axis and contour-centroid distance as the y-axis

>**finger_finger1** find the fingertip and the fingeredges of each unfold finger. This is used as the feature for recognition 

