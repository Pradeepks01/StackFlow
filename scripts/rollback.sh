#!/bin/bash
ENV=${1:-dev}
echo "Rolling back StackFlow in $ENV namespace..."
helm rollback stackflow -n $ENV
