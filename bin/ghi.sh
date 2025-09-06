#!/bin/bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${CYAN}=== GitHub Issue Creator ===${NC}\n"

# Get current repo or ask for it
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)
if [ -z "$REPO" ]; then
    read -p "Repository (owner/repo): " REPO
else
    echo -e "Repository: ${GREEN}$REPO${NC}"
    read -p "Use this repo? (Y/n): " use_repo
    [[ "$use_repo" =~ ^[Nn]$ ]] && read -p "Enter repository: " REPO
fi

# Title (required)
echo ""
read -p "📝 Title: " TITLE
while [ -z "$TITLE" ]; do
    echo -e "${YELLOW}Title is required!${NC}"
    read -p "📝 Title: " TITLE
done

# Body (multiline)
echo -e "\n📄 Description (press Enter twice to finish):"
BODY=""
while IFS= read -r line; do
    [ -z "$line" ] && break
    BODY="${BODY}${line}\n"
done

# Quick project selector
echo -e "\n📊 Fetching projects..."
PROJECTS=$(gh project list --limit 10 2>/dev/null | awk '{print NR". "$3" (Project #"$1")"}')
if [ -n "$PROJECTS" ]; then
    echo "$PROJECTS"
    read -p "Select project number (or Enter to skip): " proj_num
    if [ -n "$proj_num" ]; then
        PROJECT=$(gh project list --limit 10 | sed -n "${proj_num}p" | awk '{print $1}')
    fi
fi

# Quick label selector
echo -e "\n🏷️  Common labels:"
echo "1. bug"
echo "2. enhancement" 
echo "3. documentation"
echo "4. help wanted"
echo "5. good first issue"
echo "6. Custom"
read -p "Select numbers (space-separated) or Enter to skip: " label_nums

LABELS=""
for num in $label_nums; do
    case $num in
        1) LABELS="${LABELS}bug," ;;
        2) LABELS="${LABELS}enhancement," ;;
        3) LABELS="${LABELS}documentation," ;;
        4) LABELS="${LABELS}help wanted," ;;
        5) LABELS="${LABELS}good first issue," ;;
        6) read -p "Enter custom labels: " custom_labels
           LABELS="${LABELS}${custom_labels}," ;;
    esac
done
LABELS=${LABELS%,}  # Remove trailing comma

# Create issue
echo -e "\n${YELLOW}Creating issue...${NC}"
CMD="gh issue create -R \"$REPO\" -t \"$TITLE\""
[ -n "$BODY" ] && CMD="$CMD -b \"$BODY\""
[ -n "$PROJECT" ] && CMD="$CMD -p \"$PROJECT\""
[ -n "$LABELS" ] && CMD="$CMD -l \"$LABELS\""
CMD="$CMD -a @me"

eval $CMD

[ $? -eq 0 ] && echo -e "${GREEN}✅ Issue created!${NC}" || echo -e "❌ Failed"
