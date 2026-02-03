#!/bin/bash

# ==============================================================================
# View Logs Script
# ==============================================================================

# Function to show menu
show_menu() {
    echo "=========================="
    echo " Farm Connect - View Logs"
    echo "=========================="
    echo "1. All services"
    echo "2. Backend only"
    echo "3. Frontend only"
    echo "4. Nginx only"
    echo "5. MySQL only"
    echo "6. Exit"
    echo "=========================="
}

# Main loop
while true; do
    show_menu
    read -p "Select option (1-6): " choice
    
    case $choice in
        1)
            echo "Showing all logs (Ctrl+C to exit)..."
            docker-compose logs -f
            ;;
        2)
            echo "Showing backend logs (Ctrl+C to exit)..."
            docker-compose logs -f backend
            ;;
        3)
            echo "Showing frontend logs (Ctrl+C to exit)..."
            docker-compose logs -f frontend
            ;;
        4)
            echo "Showing nginx logs (Ctrl+C to exit)..."
            docker-compose logs -f nginx
            ;;
        5)
            echo "Showing MySQL logs (Ctrl+C to exit)..."
            docker-compose logs -f mysql
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    
    echo ""
done
