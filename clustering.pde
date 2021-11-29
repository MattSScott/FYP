void genNeighbourhoods(Agent[] agents, int n_clusters) {
  PVector[] centers = new PVector[n_clusters];
  int[] chosenPoints = new int[n_clusters];

  for (int i=0; i<chosenPoints.length; i++) {
    int randomIndex = int(random(agents.length));
    chosenPoints[i] = randomIndex;
    for (int j=0; j<i; j++) {
      if (chosenPoints[i] == chosenPoints[j]) {
        i--;
      }
    }
  }

  for (int i=0; i<centers.length; i++) {
    centers[i] = agents[chosenPoints[i]].pos;
  }

  while (true) {
    for (int i=0; i<agents.length; i++) {
      agents[i].minDistanceToNeighbourhood = agents[i].pos.dist(centers[0]);
      agents[i].neighbourhood = 0;
      for (int j=1; j<centers.length; j++) {
        float currDist = agents[i].pos.dist(centers[j]);
        if (currDist < agents[i].minDistanceToNeighbourhood) {
          agents[i].minDistanceToNeighbourhood = currDist;
          agents[i].neighbourhood = j;
        }
      }
    }
    PVector[] newCenters = new PVector[n_clusters];
    for (int i=0; i<newCenters.length; i++) {
      newCenters[i] = new PVector(0.0, 0.0);
      int pointsPerCluster = 0;
      for (int j=0; j<agents.length; j++) {
        if (agents[j].neighbourhood == i) {
          newCenters[i].add(agents[j].pos);
          pointsPerCluster++;
        }
      }
      newCenters[i].div(pointsPerCluster);
    }
    boolean noChange = true;
    for (int i=0; i<newCenters.length; i++) {
      if (newCenters[i].x != centers[i].x || newCenters[i].y != centers[i].y) {
        noChange = false;
        break;
      }
    }
    if (noChange) {
      break;
    }
    centers = newCenters;
  }
  //for (Point p : points) {
  //  float newCol = map(p.cluster, 0, n_clusters-1, 0, 255);
  //  fill(newCol, 50, 50);
  //  p.show();
  //}

  for (PVector centroid : centers) {
    fill(0, 255, 0);
    ellipse(centroid.x, centroid.y, 10, 10);
  }
}
