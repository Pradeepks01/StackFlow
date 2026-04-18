#!/bin/bash
echo "Rolling back deployment..."
helm rollback stackflow 1
